//
//  HalfModalPresentable.swift
//  FunctionConfirm
//
//  Created by yusaku maki on 2020/04/14.
//  Copyright © 2020 牧宥作. All rights reserved.
//

import UIKit

public protocol HalfModalPresentable: AnyObject {
    var halfScrollable: UIScrollView? { get }
    var topOffset: CGFloat { get }
    var shortFormHeight: HalfModalHeight { get }
    var longFormHeight: HalfModalHeight { get }
    var cornerRadius: CGFloat { get }
    var springDamping: CGFloat { get }
    var transitionDuration: Double { get }
    var transitionAnimationOptions: UIView.AnimationOptions { get }
    var halfModalBackgroundColor: UIColor { get }
    var dragIndicatorBackgroundColor: UIColor { get }
    var scrollIndicatorInsets: UIEdgeInsets { get }
    var anchorModalToLongForm: Bool { get }
    var allowsExtendedHalfScrolling: Bool { get }
    var allowsDragToDismiss: Bool { get }
    var allowsTapToDismiss: Bool { get }
    var isUserInteractionEnabled: Bool { get }
    var isHapticFeedbackEnabled: Bool { get }
    var shouldRoundTopCorners: Bool { get }
    var showDragIndicator: Bool { get }
    func shouldRespond(to halfModalGestureRecognizer: UIPanGestureRecognizer) -> Bool
    func willRespond(to halfModalGestureRecognizer: UIPanGestureRecognizer)
    func shouldPrioritize(halfModalGestureRecognizer: UIPanGestureRecognizer) -> Bool
    func shouldTransition(to state: HalfModalPresentationState) -> Bool
    func willTransition(to state: HalfModalPresentationState)
    func halfModalWillDismiss()
    func halfModalDidDismiss()
}

public extension HalfModalPresentable where Self: UIViewController {

    typealias AnimationBlockType = () -> Void
    typealias AnimationCompletionType = (Bool) -> Void
    typealias LayoutType = UIViewController & HalfModalPresentable

    func halfModalTransition(to state: HalfModalPresentationState) {
        presentedVC?.transition(to: state)
    }

    func halfModalSetNeedsLayoutUpdate() {
        presentedVC?.setNeedsLayoutUpdate()
    }

    func halfModalPerformUpdates(_ updates: () -> Void) {
        presentedVC?.performUpdates(updates)
    }

    func halfModalAnimate(_ animationBlock: @escaping AnimationBlockType, _ completion: AnimationCompletionType? = nil) {
        HalfModalAnimator.animate(animationBlock, config: self, completion)
    }
}

public extension HalfModalPresentable where Self: UIViewController {

    var topOffset: CGFloat {
        return topLayoutOffset + 21.0
    }

    var shortFormHeight: HalfModalHeight {
        return longFormHeight
    }

    var longFormHeight: HalfModalHeight {

        guard let scrollView = halfScrollable
            else { return .maxHeight }

        // called once during presentation and stored
        scrollView.layoutIfNeeded()
        return .contentHeight(scrollView.contentSize.height)
    }

    var cornerRadius: CGFloat {
        return 8.0
    }

    var springDamping: CGFloat {
        return 0.8
    }

    var transitionDuration: Double {
        return HalfModalAnimator.Constants.defaultTransitionDuration
    }

    var transitionAnimationOptions: UIView.AnimationOptions {
        return [.curveEaseInOut, .allowUserInteraction, .beginFromCurrentState]
    }

    var halfModalBackgroundColor: UIColor {
        return UIColor.black.withAlphaComponent(0.7)
    }

    var dragIndicatorBackgroundColor: UIColor {
        return UIColor.lightGray
    }

    var scrollIndicatorInsets: UIEdgeInsets {
        let top = shouldRoundTopCorners ? cornerRadius : 0
        return UIEdgeInsets(top: CGFloat(top), left: 0, bottom: bottomLayoutOffset, right: 0)
    }

    var anchorModalToLongForm: Bool {
        return true
    }

    var allowsExtendedHalfScrolling: Bool {
        guard let scrollView = halfScrollable else { return false }
        scrollView.layoutIfNeeded()
        return scrollView.contentSize.height > (scrollView.frame.height - bottomLayoutOffset)
    }

    var allowsDragToDismiss: Bool {
        return true
    }

    var allowsTapToDismiss: Bool {
        return true
    }

    var isUserInteractionEnabled: Bool {
        return true
    }

    var isHapticFeedbackEnabled: Bool {
        return true
    }

    var shouldRoundTopCorners: Bool {
        return isHalfModalPresented
    }

    var showDragIndicator: Bool {
        return shouldRoundTopCorners
    }

    func shouldRespond(to halfModalGestureRecognizer: UIPanGestureRecognizer) -> Bool {
        return true
    }

    func willRespond(to halfModalGestureRecognizer: UIPanGestureRecognizer) {}

    func shouldTransition(to state: HalfModalPresentationState) -> Bool {
        return true
    }

    func shouldPrioritize(halfModalGestureRecognizer: UIPanGestureRecognizer) -> Bool {
        return false
    }

    func willTransition(to state: HalfModalPresentationState) {}

    func halfModalWillDismiss() {}

    func halfModalDidDismiss() {}
}

extension HalfModalPresentable where Self: UIViewController {
    var presentedVC: HalfModalPresentationController? {
        return presentationController as? HalfModalPresentationController
    }

    var topLayoutOffset: CGFloat {
        guard let rootVC = rootViewController else { return 0 }
        if #available(iOS 11.0, *) { return rootVC.view.safeAreaInsets.top } else { return rootVC.topLayoutGuide.length }
    }

    var bottomLayoutOffset: CGFloat {
       guard let rootVC = rootViewController else { return 0 }

        if #available(iOS 11.0, *) { return rootVC.view.safeAreaInsets.bottom } else { return rootVC.bottomLayoutGuide.length }
    }

    var shortFormYPos: CGFloat {
        guard !UIAccessibility.isVoiceOverRunning else { return longFormYPos }
        let shortFormYPos = topMargin(from: shortFormHeight) + topOffset
        return max(shortFormYPos, longFormYPos)
    }

    var longFormYPos: CGFloat {
        return max(topMargin(from: longFormHeight), topMargin(from: .maxHeight)) + topOffset
    }

    var bottomYPos: CGFloat {
        guard let container = presentedVC?.containerView else { return view.bounds.height }
        return container.bounds.size.height - topOffset
    }

    func topMargin(from: HalfModalHeight) -> CGFloat {
        switch from {
        case .maxHeight:
            return 0.0
        case .maxHeightWithTopInset(let inset):
            return inset
        case .contentHeight(let height):
            return bottomYPos - (height + bottomLayoutOffset)
        case .contentHeightIgnoringSafeArea(let height):
            return bottomYPos - height
        case .intrinsicHeight:
            view.layoutIfNeeded()
            let targetSize = CGSize(width: (presentedVC?.containerView?.bounds ?? UIScreen.main.bounds).width,
                                    height: UIView.layoutFittingCompressedSize.height)
            let intrinsicHeight = view.systemLayoutSizeFitting(targetSize).height
            return bottomYPos - (intrinsicHeight + bottomLayoutOffset)
        }
    }

    private var rootViewController: UIViewController? {
        guard let application = UIApplication.value(forKeyPath: #keyPath(UIApplication.shared)) as? UIApplication else { return nil }
        return application.keyWindow?.rootViewController
    }
}
