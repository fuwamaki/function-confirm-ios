//
//  SemiModalDelegate.swift
//  FunctionConfirm
//
//  Created by yusaku maki on 2020/04/14.
//  Copyright © 2020 牧宥作. All rights reserved.
//

import UIKit

protocol SemiModalDelegate: AnyObject {
    var semiScrollable: UIScrollView? { get }
    var topOffset: CGFloat { get }
    var shortFormHeight: SemiModalHeight { get }
    var longFormHeight: SemiModalHeight { get }
    var cornerRadius: CGFloat { get }
    var springDamping: CGFloat { get }
    var transitionDuration: Double { get }
    var transitionAnimationOptions: UIView.AnimationOptions { get }
    var semiModalBackgroundColor: UIColor { get }
    func willRespond(to semiModalGestureRecognizer: UIPanGestureRecognizer)
    func shouldTransition(to state: SemiModalPresentationState) -> Bool
    func willTransition(to state: SemiModalPresentationState)
    func semiModalViewWillDisappear()
    func semiModalDidDisappear()
}

// MARK: protocol functions
extension SemiModalDelegate where Self: UIViewController {
    var semiScrollable: UIScrollView? {
        return nil
    }

    var topOffset: CGFloat {
        return topLayoutOffset + 24.0
    }

    var shortFormHeight: SemiModalHeight {
        return .contentHeight(300)
    }

    var longFormHeight: SemiModalHeight {
        return .maxHeightWithTopInset(40)
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

    var semiModalBackgroundColor: UIColor {
        return UIColor.black.withAlphaComponent(0.7)
    }

    func willRespond(to semiModalGestureRecognizer: UIPanGestureRecognizer) {}

    func shouldTransition(to state: SemiModalPresentationState) -> Bool {
        return true
    }

    func willTransition(to state: SemiModalPresentationState) {}

    func semiModalViewWillDisappear() {}

    func semiModalDidDisappear() {}
}

// MARK: typealias, private
extension SemiModalDelegate where Self: UIViewController {
    typealias AnimationBlockType = () -> Void
    typealias AnimationCompletionType = (Bool) -> Void
    typealias LayoutType = UIViewController & SemiModalDelegate

    private var rootViewController: UIViewController? {
        let keyWindow = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first
        return keyWindow?.rootViewController
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

    var allowsExtendedSemiScrolling: Bool {
        guard let scrollView = semiScrollable else { return false }
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
