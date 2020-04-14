//
//  SemiModalPresentationController.swift
//  FunctionConfirm
//
//  Created by yusaku maki on 2020/04/14.
//  Copyright © 2020 牧宥作. All rights reserved.
//

import UIKit

class SemiModalPresentationController: UIPresentationController {

    private var isPresentedViewAnimating = false
    private var extendsSemiScrolling = true
    private var scrollViewYOffset: CGFloat = 0.0
    private var scrollObserver: NSKeyValueObservation?
    private var shortFormYPosition: CGFloat = 0
    private var longFormYPosition: CGFloat = 0

    private var semiModalDelegate: SemiModalDelegate.LayoutType {
        return presentedViewController as! SemiModalDelegate.LayoutType
    }

    private var isPresentedViewAnchored: Bool {
        return !isPresentedViewAnimating && extendsSemiScrolling && presentedView.frame.minY.rounded() <= longFormYPosition.rounded()
    }

    private lazy var backgroundView: DimmedView = {
        let view = DimmedView(dimColor: semiModalDelegate.semiModalBackgroundColor)
        view.didTap = { [weak self] _ in
            self?.semiModalDelegate.dismiss(animated: true)
        }
        return view
    }()

    private lazy var semiContainerView: SemiContainerView = {
        return SemiContainerView(presentedView: semiModalDelegate.view, frame: containerView?.frame ?? .zero)
    }()

    private lazy var panGestureRecognizer: UIPanGestureRecognizer = {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(didSemiOnPresentedView(_ :)))
        gesture.minimumNumberOfTouches = 1
        gesture.maximumNumberOfTouches = 1
        gesture.delegate = self
        return gesture
    }()

    deinit {
        scrollObserver?.invalidate()
    }
}

// MARK: UIPresentationController
extension SemiModalPresentationController {
    override var presentedView: UIView {
        return semiContainerView
    }

    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        configureViewLayout()
    }

    override func presentationTransitionWillBegin() {
        guard let containerView = containerView else { return }
        layoutBackgroundView(in: containerView)
        layoutPresentedView(in: containerView)
        configureScrollViewInsets()
        guard let coordinator = semiModalDelegate.transitionCoordinator else {
            backgroundView.dimState = .max
            return
        }
        coordinator.animate(alongsideTransition: { _ in
            self.backgroundView.dimState = .max
            self.semiModalDelegate.setNeedsStatusBarAppearanceUpdate()
        })
    }

    override func presentationTransitionDidEnd(_ completed: Bool) {
        guard !completed else { return }
        backgroundView.removeFromSuperview()
    }

    override func dismissalTransitionWillBegin() {
        semiModalDelegate.semiModalViewWillDisappear()
        guard let coordinator = semiModalDelegate.transitionCoordinator else {
            backgroundView.dimState = .off
            return
        }
        coordinator.animate(alongsideTransition: { _ in
            self.backgroundView.dimState = .off
            self.presentingViewController.setNeedsStatusBarAppearanceUpdate()
        })
    }

    override func dismissalTransitionDidEnd(_ completed: Bool) {
        guard completed else { return }
        semiModalDelegate.semiModalDidDisappear()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { _ in
            self.adjustPresentedViewFrame()
            if self.semiModalDelegate.isSemiModalPresented {
                self.addRoundedCorners(to: self.presentedView)
            }
        })
    }
}

extension SemiModalPresentationController {
    func transition(to state: SemiModalPresentationState) {
        guard semiModalDelegate.shouldTransition(to: state) == true else { return }
        semiModalDelegate.willTransition(to: state)
        switch state {
        case .shortForm:
            snap(toYPosition: shortFormYPosition)
        case .longForm:
            snap(toYPosition: longFormYPosition)
        }
    }

    func performUpdates(_ updates: () -> Void) {
        guard let scrollView = semiModalDelegate.semiScrollable else { return }
        scrollObserver?.invalidate()
        scrollObserver = nil
        updates()
        trackScrolling(scrollView)
        observe(scrollView: scrollView)
    }

    func setNeedsLayoutUpdate() {
        configureViewLayout()
        adjustPresentedViewFrame()
        observe(scrollView: semiModalDelegate.semiScrollable)
        configureScrollViewInsets()
    }
}

extension SemiModalPresentationController {
    private func layoutPresentedView(in containerView: UIView) {
        containerView.addSubview(presentedView)
        containerView.addGestureRecognizer(panGestureRecognizer)
        if semiModalDelegate.isSemiModalPresented {
            addRoundedCorners(to: presentedView)
        }
        setNeedsLayoutUpdate()
        adjustSemiContainerBackgroundColor()
    }

    private func adjustPresentedViewFrame() {
        guard let frame = containerView?.frame else { return }
        let adjustedSize = CGSize(width: frame.size.width, height: frame.size.height - longFormYPosition)
        semiContainerView.frame.size = frame.size
        if ![shortFormYPosition, longFormYPosition].contains(semiContainerView.frame.origin.y) {
            let yPosition = semiContainerView.frame.origin.y - semiContainerView.frame.height + frame.height
            presentedView.frame.origin.y = max(yPosition, longFormYPosition)
        }
        semiContainerView.frame.origin.x = frame.origin.x
        semiModalDelegate.view.frame = CGRect(origin: .zero, size: adjustedSize)
    }

    private func adjustSemiContainerBackgroundColor() {
        semiContainerView.backgroundColor = semiModalDelegate.view.backgroundColor ?? semiModalDelegate.semiScrollable?.backgroundColor
    }

    private func layoutBackgroundView(in containerView: UIView) {
        containerView.addSubview(backgroundView)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        backgroundView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        backgroundView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
    }

    private func configureViewLayout() {
        shortFormYPosition = semiModalDelegate.shortFormYPos
        longFormYPosition = semiModalDelegate.longFormYPos
        extendsSemiScrolling = semiModalDelegate.allowsExtendedSemiScrolling
    }

    private func configureScrollViewInsets() {
        guard
            let scrollView = semiModalDelegate.semiScrollable,
            !scrollView.isScrolling else { return }
        scrollView.showsVerticalScrollIndicator = false
        scrollView.scrollIndicatorInsets = semiModalDelegate.scrollIndicatorInsets
        scrollView.contentInset.bottom = presentingViewController.view.safeAreaInsets.bottom
        scrollView.contentInsetAdjustmentBehavior = .never
    }

    @objc private func didSemiOnPresentedView(_ recognizer: UIPanGestureRecognizer) {
        guard
            shouldRespond(to: recognizer),
            let containerView = containerView else {
                recognizer.setTranslation(.zero, in: recognizer.view)
                return
        }
        let velocity = recognizer.velocity(in: presentedView)
        switch (recognizer.state, isVelocityWithinSensitivityRange(velocity.y), velocity.y) {
        case (.began, _, _), (.changed, _, _):
            respond(to: recognizer)
            if presentedView.frame.origin.y == longFormYPosition && extendsSemiScrolling {
                semiModalDelegate.willTransition(to: .longForm)
            }
        case (_, true, let y) where y < 0:
            transition(to: .longForm)
        case (_, true, _) where nearest(to: presentedView.frame.minY,
                                        inValues: [longFormYPosition,
                                                   containerView.bounds.height]) == longFormYPosition && presentedView.frame.minY < shortFormYPosition:
            transition(to: .shortForm)
        case (_, true, _):
            semiModalDelegate.dismiss(animated: true)
        default:
            switch nearest(to: presentedView.frame.minY, inValues: [containerView.bounds.height, shortFormYPosition, longFormYPosition]) {
            case longFormYPosition:
                transition(to: .longForm)
            case shortFormYPosition:
                transition(to: .shortForm)
            default:
                semiModalDelegate.dismiss(animated: true)
            }
        }
    }

    private func shouldRespond(to panGestureRecognizer: UIPanGestureRecognizer) -> Bool {
        return !shouldFail(panGestureRecognizer: panGestureRecognizer)
    }

    private func respond(to panGestureRecognizer: UIPanGestureRecognizer) {
        semiModalDelegate.willRespond(to: panGestureRecognizer)
        var yDisplacement = panGestureRecognizer.translation(in: presentedView).y
        if presentedView.frame.origin.y < longFormYPosition {
            yDisplacement /= 2.0
        }
        adjust(toYPosition: presentedView.frame.origin.y + yDisplacement)
        panGestureRecognizer.setTranslation(.zero, in: presentedView)
    }

    private func shouldFail(panGestureRecognizer: UIPanGestureRecognizer) -> Bool {
        guard
            isPresentedViewAnchored,
            let scrollView = semiModalDelegate.semiScrollable,
            scrollView.contentOffset.y > 0 else { return false }
        let loc = panGestureRecognizer.location(in: presentedView)
        return (scrollView.frame.contains(loc) || scrollView.isScrolling)
    }

    private func isVelocityWithinSensitivityRange(_ velocity: CGFloat) -> Bool {
        return (abs(velocity) - 300) > 0
    }

    private func snap(toYPosition yPos: CGFloat) {
        SemiModalAnimator.animate({ [weak self] in
            self?.adjust(toYPosition: yPos)
            self?.isPresentedViewAnimating = true
            }, semiModalDelegate: semiModalDelegate, { [weak self] didComplete in
                self?.isPresentedViewAnimating = !didComplete
        })
    }

    private func adjust(toYPosition yPos: CGFloat) {
        presentedView.frame.origin.y = max(yPos, longFormYPosition)
        guard presentedView.frame.origin.y > shortFormYPosition else {
            backgroundView.dimState = .max
            return
        }
        let yDisplacementFromShortForm = presentedView.frame.origin.y - shortFormYPosition
        backgroundView.dimState = .percent(1.0 - (yDisplacementFromShortForm / presentedView.frame.height))
    }

    private func nearest(to number: CGFloat, inValues values: [CGFloat]) -> CGFloat {
        guard let nearestVal = values.min(by: { abs(number - $0) < abs(number - $1) }) else { return number }
        return nearestVal
    }

    private func observe(scrollView: UIScrollView?) {
        scrollObserver?.invalidate()
        scrollObserver = scrollView?.observe(\.contentOffset, options: .old) { [weak self] scrollView, change in
            guard self?.containerView != nil else { return }
            self?.didSemiOnScrollView(scrollView, change: change)
        }
    }

    private func didSemiOnScrollView(_ scrollView: UIScrollView, change: NSKeyValueObservedChange<CGPoint>) {
        guard
            !semiModalDelegate.isBeingDismissed,
            !semiModalDelegate.isBeingPresented
            else { return }
        if !isPresentedViewAnchored && scrollView.contentOffset.y > 0 {
            haltScrolling(scrollView)
        } else if scrollView.isScrolling || isPresentedViewAnimating {
            isPresentedViewAnchored ? trackScrolling(scrollView) : haltScrolling(scrollView)
        } else if semiModalDelegate.view.isKind(of: UIScrollView.self) && !isPresentedViewAnimating && scrollView.contentOffset.y <= 0 {
            handleScrollViewTopBounce(scrollView: scrollView, change: change)
        } else {
            trackScrolling(scrollView)
        }
    }

    private func haltScrolling(_ scrollView: UIScrollView) {
        scrollView.setContentOffset(CGPoint(x: 0, y: scrollViewYOffset), animated: false)
        scrollView.showsVerticalScrollIndicator = false
    }

    private func trackScrolling(_ scrollView: UIScrollView) {
        scrollViewYOffset = max(scrollView.contentOffset.y, 0)
        scrollView.showsVerticalScrollIndicator = true
    }

    private func handleScrollViewTopBounce(scrollView: UIScrollView, change: NSKeyValueObservedChange<CGPoint>) {
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

    private func addRoundedCorners(to view: UIView) {
        let radius = semiModalDelegate.cornerRadius
        let path = UIBezierPath(roundedRect: view.bounds,
                                byRoundingCorners: [.topLeft, .topRight],
                                cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        view.layer.mask = mask
        view.layer.shouldRasterize = true
        view.layer.rasterizationScale = UIScreen.main.scale
    }
}

// MARK: UIGestureRecognizerDelegate
extension SemiModalPresentationController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return otherGestureRecognizer.view == semiModalDelegate.semiScrollable
    }
}

// MARK: UIScrollView
private extension UIScrollView {
    var isScrolling: Bool {
        return isDragging && !isDecelerating || isTracking
    }
}
