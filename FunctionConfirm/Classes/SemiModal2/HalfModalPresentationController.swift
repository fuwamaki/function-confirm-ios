//
//  HalfModalPresentationController.swift
//  FunctionConfirm
//
//  Created by yusaku maki on 2020/04/14.
//  Copyright © 2020 牧宥作. All rights reserved.
//

import UIKit

open class HalfModalPresentationController: UIPresentationController {

    struct Constants {
        static let indicatorYOffset = CGFloat(8.0)
        static let snapMovementSensitivity = CGFloat(0.7)
        static let dragIndicatorSize = CGSize(width: 36.0, height: 5.0)
    }

    private var isPresentedViewAnimating = false
    private var extendsHalfScrolling = true
    private var anchorModalToLongForm = true
    private var scrollViewYOffset: CGFloat = 0.0
    private var scrollObserver: NSKeyValueObservation?
    private var shortFormYPosition: CGFloat = 0
    private var longFormYPosition: CGFloat = 0

    private var anchoredYPosition: CGFloat {
        let defaultTopOffset = presentable?.topOffset ?? 0
        return anchorModalToLongForm ? longFormYPosition : defaultTopOffset
    }

    private var presentable: HalfModalPresentable? {
        return presentedViewController as? HalfModalPresentable
    }

    private lazy var backgroundView: DimmedView = {
        let view: DimmedView
        if let color = presentable?.halfModalBackgroundColor {
            view = DimmedView(dimColor: color)
        } else {
            view = DimmedView()
        }
        view.didTap = { [weak self] _ in
            if self?.presentable?.allowsTapToDismiss == true {
                self?.presentedViewController.dismiss(animated: true)
            }
        }
        return view
    }()

    private lazy var halfContainerView: HalfContainerView = {
        let frame = containerView?.frame ?? .zero
        return HalfContainerView(presentedView: presentedViewController.view, frame: frame)
    }()

    private lazy var dragIndicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = presentable?.dragIndicatorBackgroundColor
        view.layer.cornerRadius = Constants.dragIndicatorSize.height / 2.0
        return view
    }()

    public override var presentedView: UIView {
        return halfContainerView
    }

    private lazy var panGestureRecognizer: UIPanGestureRecognizer = {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(didHalfOnPresentedView(_ :)))
        gesture.minimumNumberOfTouches = 1
        gesture.maximumNumberOfTouches = 1
        gesture.delegate = self
        return gesture
    }()

    deinit {
        scrollObserver?.invalidate()
    }

    override public func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        configureViewLayout()
    }

    override public func presentationTransitionWillBegin() {
        guard let containerView = containerView else { return }
        layoutBackgroundView(in: containerView)
        layoutPresentedView(in: containerView)
        configureScrollViewInsets()
        guard let coordinator = presentedViewController.transitionCoordinator else {
            backgroundView.dimState = .max
            return
        }
        coordinator.animate(alongsideTransition: { [weak self] _ in
            self?.backgroundView.dimState = .max
            self?.presentedViewController.setNeedsStatusBarAppearanceUpdate()
        })
    }

    override public func presentationTransitionDidEnd(_ completed: Bool) {
        if completed { return }
        backgroundView.removeFromSuperview()
    }

    override public func dismissalTransitionWillBegin() {
        presentable?.halfModalWillDismiss()
        guard let coordinator = presentedViewController.transitionCoordinator else {
            backgroundView.dimState = .off
            return
        }
        coordinator.animate(alongsideTransition: { [weak self] _ in
            self?.dragIndicatorView.alpha = 0.0
            self?.backgroundView.dimState = .off
            self?.presentingViewController.setNeedsStatusBarAppearanceUpdate()
        })
    }

    override public func dismissalTransitionDidEnd(_ completed: Bool) {
        if !completed { return }
        presentable?.halfModalDidDismiss()
    }

    override public func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { [weak self] _ in
            guard
                let self = self,
                let presentable = self.presentable
                else { return }
            self.adjustPresentedViewFrame()
            if presentable.shouldRoundTopCorners {
                self.addRoundedCorners(to: self.presentedView)
            }
        })
    }
}

public extension HalfModalPresentationController {
    func transition(to state: HalfModalPresentationState) {
        guard presentable?.shouldTransition(to: state) == true else { return }
        presentable?.willTransition(to: state)
        switch state {
        case .shortForm:
            snap(toYPosition: shortFormYPosition)
        case .longForm:
            snap(toYPosition: longFormYPosition)
        }
    }

    func performUpdates(_ updates: () -> Void) {
        guard let scrollView = presentable?.halfScrollable else { return }
        scrollObserver?.invalidate()
        scrollObserver = nil
        updates()
        trackScrolling(scrollView)
        observe(scrollView: scrollView)
    }

    func setNeedsLayoutUpdate() {
        configureViewLayout()
        adjustPresentedViewFrame()
        observe(scrollView: presentable?.halfScrollable)
        configureScrollViewInsets()
    }
}

// MARK: - Presented View Layout Configuration
private extension HalfModalPresentationController {
    var isPresentedViewAnchored: Bool {
        if !isPresentedViewAnimating
            && extendsHalfScrolling
            && presentedView.frame.minY.rounded() <= anchoredYPosition.rounded() {
            return true
        }
        return false
    }

    func layoutPresentedView(in containerView: UIView) {
        guard let presentable = presentable else { return }
        containerView.addSubview(presentedView)
        containerView.addGestureRecognizer(panGestureRecognizer)
        if presentable.showDragIndicator {
            addDragIndicatorView(to: presentedView)
        }
        if presentable.shouldRoundTopCorners {
            addRoundedCorners(to: presentedView)
        }
        setNeedsLayoutUpdate()
        adjustHalfContainerBackgroundColor()
    }

    func adjustPresentedViewFrame() {
        guard let frame = containerView?.frame else { return }
        let adjustedSize = CGSize(width: frame.size.width, height: frame.size.height - anchoredYPosition)
        let halfFrame = halfContainerView.frame
        halfContainerView.frame.size = frame.size
        if ![shortFormYPosition, longFormYPosition].contains(halfFrame.origin.y) {
            let yPosition = halfFrame.origin.y - halfFrame.height + frame.height
            presentedView.frame.origin.y = max(yPosition, anchoredYPosition)
        }
        halfContainerView.frame.origin.x = frame.origin.x
        presentedViewController.view.frame = CGRect(origin: .zero, size: adjustedSize)
    }

    func adjustHalfContainerBackgroundColor() {
        halfContainerView.backgroundColor = presentedViewController.view.backgroundColor
            ?? presentable?.halfScrollable?.backgroundColor
    }

    func layoutBackgroundView(in containerView: UIView) {
        containerView.addSubview(backgroundView)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        backgroundView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        backgroundView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
    }

    func addDragIndicatorView(to view: UIView) {
        view.addSubview(dragIndicatorView)
        dragIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        dragIndicatorView.bottomAnchor.constraint(equalTo: view.topAnchor, constant: -Constants.indicatorYOffset).isActive = true
        dragIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        dragIndicatorView.widthAnchor.constraint(equalToConstant: Constants.dragIndicatorSize.width).isActive = true
        dragIndicatorView.heightAnchor.constraint(equalToConstant: Constants.dragIndicatorSize.height).isActive = true
    }

    func configureViewLayout() {
        guard let layoutPresentable = presentedViewController as? HalfModalPresentable.LayoutType
            else { return }
        shortFormYPosition = layoutPresentable.shortFormYPos
        longFormYPosition = layoutPresentable.longFormYPos
        anchorModalToLongForm = layoutPresentable.anchorModalToLongForm
        extendsHalfScrolling = layoutPresentable.allowsExtendedHalfScrolling
        containerView?.isUserInteractionEnabled = layoutPresentable.isUserInteractionEnabled
    }

    func configureScrollViewInsets() {
        guard
            let scrollView = presentable?.halfScrollable,
            !scrollView.isScrolling
            else { return }
        scrollView.showsVerticalScrollIndicator = false
        scrollView.scrollIndicatorInsets = presentable?.scrollIndicatorInsets ?? .zero
        scrollView.contentInset.bottom = presentingViewController.bottomLayoutGuide.length
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }
    }
}

private extension HalfModalPresentationController {
    @objc func didHalfOnPresentedView(_ recognizer: UIPanGestureRecognizer) {
        guard
            shouldRespond(to: recognizer),
            let containerView = containerView
            else {
                recognizer.setTranslation(.zero, in: recognizer.view)
                return
        }
        switch recognizer.state {
        case .began, .changed:
            respond(to: recognizer)
            if presentedView.frame.origin.y == anchoredYPosition && extendsHalfScrolling {
                presentable?.willTransition(to: .longForm)
            }
        default:
            let velocity = recognizer.velocity(in: presentedView)
            if isVelocityWithinSensitivityRange(velocity.y) {
                if velocity.y < 0 {
                    transition(to: .longForm)
                } else if (nearest(to: presentedView.frame.minY, inValues: [longFormYPosition, containerView.bounds.height]) == longFormYPosition
                    && presentedView.frame.minY < shortFormYPosition) || presentable?.allowsDragToDismiss == false {
                    transition(to: .shortForm)
                } else {
                    presentedViewController.dismiss(animated: true)
                }
            } else {
                let position = nearest(to: presentedView.frame.minY, inValues: [containerView.bounds.height, shortFormYPosition, longFormYPosition])
                if position == longFormYPosition {
                    transition(to: .longForm)
                } else if position == shortFormYPosition || presentable?.allowsDragToDismiss == false {
                    transition(to: .shortForm)
                } else {
                    presentedViewController.dismiss(animated: true)
                }
            }
        }
    }

    func shouldRespond(to panGestureRecognizer: UIPanGestureRecognizer) -> Bool {
        guard
            presentable?.shouldRespond(to: panGestureRecognizer) == true ||
                !(panGestureRecognizer.state == .began || panGestureRecognizer.state == .cancelled)
            else {
                panGestureRecognizer.isEnabled = false
                panGestureRecognizer.isEnabled = true
                return false
        }
        return !shouldFail(panGestureRecognizer: panGestureRecognizer)
    }

    func respond(to panGestureRecognizer: UIPanGestureRecognizer) {
        presentable?.willRespond(to: panGestureRecognizer)
        var yDisplacement = panGestureRecognizer.translation(in: presentedView).y
        if presentedView.frame.origin.y < longFormYPosition {
            yDisplacement /= 2.0
        }
        adjust(toYPosition: presentedView.frame.origin.y + yDisplacement)
        panGestureRecognizer.setTranslation(.zero, in: presentedView)
    }

    func shouldFail(panGestureRecognizer: UIPanGestureRecognizer) -> Bool {
        guard !shouldPrioritize(panGestureRecognizer: panGestureRecognizer) else {
            presentable?.halfScrollable?.panGestureRecognizer.isEnabled = false
            presentable?.halfScrollable?.panGestureRecognizer.isEnabled = true
            return false
        }
        guard
            isPresentedViewAnchored,
            let scrollView = presentable?.halfScrollable,
            scrollView.contentOffset.y > 0
            else { return false }
        let loc = panGestureRecognizer.location(in: presentedView)
        return (scrollView.frame.contains(loc) || scrollView.isScrolling)
    }

    func shouldPrioritize(panGestureRecognizer: UIPanGestureRecognizer) -> Bool {
        return panGestureRecognizer.state == .began &&
            presentable?.shouldPrioritize(halfModalGestureRecognizer: panGestureRecognizer) == true
    }

    func isVelocityWithinSensitivityRange(_ velocity: CGFloat) -> Bool {
        return (abs(velocity) - (1000 * (1 - Constants.snapMovementSensitivity))) > 0
    }

    func snap(toYPosition yPos: CGFloat) {
        HalfModalAnimator.animate({ [weak self] in
            self?.adjust(toYPosition: yPos)
            self?.isPresentedViewAnimating = true
        }, config: presentable, { [weak self] didComplete in
            self?.isPresentedViewAnimating = !didComplete
        })
    }

    func adjust(toYPosition yPos: CGFloat) {
        presentedView.frame.origin.y = max(yPos, anchoredYPosition)
        guard presentedView.frame.origin.y > shortFormYPosition else {
            backgroundView.dimState = .max
            return
        }
        let yDisplacementFromShortForm = presentedView.frame.origin.y - shortFormYPosition
        backgroundView.dimState = .percent(1.0 - (yDisplacementFromShortForm / presentedView.frame.height))
    }

    func nearest(to number: CGFloat, inValues values: [CGFloat]) -> CGFloat {
        guard let nearestVal = values.min(by: { abs(number - $0) < abs(number - $1) }) else { return number }
        return nearestVal
    }
}

private extension HalfModalPresentationController {
    func observe(scrollView: UIScrollView?) {
        scrollObserver?.invalidate()
        scrollObserver = scrollView?.observe(\.contentOffset, options: .old) { [weak self] scrollView, change in
            guard self?.containerView != nil else { return }
            self?.didHalfOnScrollView(scrollView, change: change)
        }
    }

    func didHalfOnScrollView(_ scrollView: UIScrollView, change: NSKeyValueObservedChange<CGPoint>) {
        guard
            !presentedViewController.isBeingDismissed,
            !presentedViewController.isBeingPresented
            else { return }
        if !isPresentedViewAnchored && scrollView.contentOffset.y > 0 {
            haltScrolling(scrollView)
        } else if scrollView.isScrolling || isPresentedViewAnimating {
            if isPresentedViewAnchored {
                trackScrolling(scrollView)
            } else {
                haltScrolling(scrollView)
            }
        } else if presentedViewController.view.isKind(of: UIScrollView.self)
            && !isPresentedViewAnimating && scrollView.contentOffset.y <= 0 {
            handleScrollViewTopBounce(scrollView: scrollView, change: change)
        } else {
            trackScrolling(scrollView)
        }
    }

    func haltScrolling(_ scrollView: UIScrollView) {
        scrollView.setContentOffset(CGPoint(x: 0, y: scrollViewYOffset), animated: false)
        scrollView.showsVerticalScrollIndicator = false
    }

    func trackScrolling(_ scrollView: UIScrollView) {
        scrollViewYOffset = max(scrollView.contentOffset.y, 0)
        scrollView.showsVerticalScrollIndicator = true
    }

    func handleScrollViewTopBounce(scrollView: UIScrollView, change: NSKeyValueObservedChange<CGPoint>) {
        guard let oldYValue = change.oldValue?.y, scrollView.isDecelerating else { return }
        let yOffset = scrollView.contentOffset.y
        let presentedSize = containerView?.frame.size ?? .zero
        presentedView.bounds.size = CGSize(width: presentedSize.width, height: presentedSize.height + yOffset)
        if oldYValue > yOffset {
            presentedView.frame.origin.y = longFormYPosition - yOffset
        } else {
            scrollViewYOffset = 0
            snap(toYPosition: longFormYPosition)
        }
        scrollView.showsVerticalScrollIndicator = false
    }
}

extension HalfModalPresentationController: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return otherGestureRecognizer.view == presentable?.halfScrollable
    }
}

private extension HalfModalPresentationController {
    func addRoundedCorners(to view: UIView) {
        let radius = presentable?.cornerRadius ?? 0
        let path = UIBezierPath(roundedRect: view.bounds,
                                byRoundingCorners: [.topLeft, .topRight],
                                cornerRadii: CGSize(width: radius, height: radius))
        if presentable?.showDragIndicator == true {
            let indicatorLeftEdgeXPos = view.bounds.width/2.0 - Constants.dragIndicatorSize.width/2.0
            drawAroundDragIndicator(currentPath: path, indicatorLeftEdgeXPos: indicatorLeftEdgeXPos)
        }
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        view.layer.mask = mask
        view.layer.shouldRasterize = true
        view.layer.rasterizationScale = UIScreen.main.scale
    }

    func drawAroundDragIndicator(currentPath path: UIBezierPath, indicatorLeftEdgeXPos: CGFloat) {
        let totalIndicatorOffset = Constants.indicatorYOffset + Constants.dragIndicatorSize.height
        path.addLine(to: CGPoint(x: indicatorLeftEdgeXPos, y: path.currentPoint.y))
        path.addLine(to: CGPoint(x: path.currentPoint.x, y: path.currentPoint.y - totalIndicatorOffset))
        path.addLine(to: CGPoint(x: path.currentPoint.x + Constants.dragIndicatorSize.width, y: path.currentPoint.y))
        path.addLine(to: CGPoint(x: path.currentPoint.x, y: path.currentPoint.y + totalIndicatorOffset))
    }
}

// MARK: - Helper Extensions
private extension UIScrollView {
    var isScrolling: Bool {
        return isDragging && !isDecelerating || isTracking
    }
}
