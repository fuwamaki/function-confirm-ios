//
//  SemiModalDelegate.swift
//  FunctionConfirm
//
//  Created by yusaku maki on 2020/04/14.
//  Copyright © 2020 牧宥作. All rights reserved.
//

import UIKit

protocol SemiModalDelegate: AnyObject {
    var halfScrollable: UIScrollView? { get }
    var topOffset: CGFloat { get }
    var shortFormHeight: SemiModalHeight { get }
    var longFormHeight: SemiModalHeight { get }
    var cornerRadius: CGFloat { get }
    var springDamping: CGFloat { get }
    var transitionDuration: Double { get }
    var transitionAnimationOptions: UIView.AnimationOptions { get }
    var halfModalBackgroundColor: UIColor { get }
    func willRespond(to halfModalGestureRecognizer: UIPanGestureRecognizer)
    func shouldTransition(to state: SemiModalPresentationState) -> Bool
    func willTransition(to state: SemiModalPresentationState)
    func halfModalViewWillDisappear()
    func halfModalDidDisappear()
}

// MARK: protocol functions
extension SemiModalDelegate where Self: UIViewController {
    // longForm時のtopOffset
    var topOffset: CGFloat {
        return topLayoutOffset + 21.0
    }

    var shortFormHeight: SemiModalHeight {
        return longFormHeight
    }

    var longFormHeight: SemiModalHeight {
        guard let scrollView = halfScrollable else { return .maxHeight }
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
        return 0.5
    }

    var transitionAnimationOptions: UIView.AnimationOptions {
        return [.curveEaseInOut, .allowUserInteraction, .beginFromCurrentState]
    }

    var halfModalBackgroundColor: UIColor {
        return UIColor.black.withAlphaComponent(0.7)
    }

    func willRespond(to halfModalGestureRecognizer: UIPanGestureRecognizer) {}

    func shouldTransition(to state: SemiModalPresentationState) -> Bool {
        return true
    }

    func willTransition(to state: SemiModalPresentationState) {}

    func halfModalViewWillDisappear() {}

    func halfModalDidDisappear() {}
}

// MARK: typealias, private
extension SemiModalDelegate where Self: UIViewController {
    typealias AnimationBlockType = () -> Void
    typealias AnimationCompletionType = (Bool) -> Void
    typealias LayoutType = UIViewController & SemiModalDelegate

    private var rootViewController: UIViewController? {
        guard let application = UIApplication.value(forKeyPath: #keyPath(UIApplication.shared)) as? UIApplication else { return nil }
        return application.keyWindow?.rootViewController
    }

    private var topLayoutOffset: CGFloat {
        return rootViewController?.view.safeAreaInsets.top ?? 0
    }

    private var bottomLayoutOffset: CGFloat {
        return rootViewController?.view.safeAreaInsets.bottom ?? 0
    }
}

extension SemiModalDelegate where Self: UIViewController {
    var presentedVC: SemiModalPresentationController? {
        return presentationController as? SemiModalPresentationController
    }

    var allowsExtendedHalfScrolling: Bool {
        guard let scrollView = halfScrollable else { return false }
        scrollView.layoutIfNeeded()
        return scrollView.contentSize.height > (scrollView.frame.height - bottomLayoutOffset)
    }

    // UIScrollViewのスクロール位置を表すIndicatorの位置
    var scrollIndicatorInsets: UIEdgeInsets {
        let top = isSemiModalPresented ? cornerRadius : 0
        return UIEdgeInsets(top: CGFloat(top), left: 0, bottom: bottomLayoutOffset, right: 0)
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

    func topMargin(from: SemiModalHeight) -> CGFloat {
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
}
