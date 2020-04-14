//
//  UIViewController+HalfModal.swift
//  FunctionConfirm
//
//  Created by yusaku maki on 2020/04/14.
//  Copyright © 2020 牧宥作. All rights reserved.
//

import UIKit

extension UIViewController: HalfModalPresenter {
    public var isHalfModalPresented: Bool {
        return (transitioningDelegate as? HalfModalPresentationDelegate) != nil
    }

    public func presentHalfModal(_ viewController: HalfModalPresentable.LayoutType, sourceView: UIView? = nil, sourceRect: CGRect = .zero) {
        viewController.modalPresentationStyle = .custom
        viewController.modalPresentationCapturesStatusBarAppearance = true
        viewController.transitioningDelegate = HalfModalPresentationDelegate.default
        present(viewController, animated: true, completion: nil)
    }
}

public class HalfModalPresentationDelegate: NSObject {
    public static var `default`: HalfModalPresentationDelegate = {
        return HalfModalPresentationDelegate()
    }()
}

extension HalfModalPresentationDelegate: UIViewControllerTransitioningDelegate {
    public func animationController(forPresented presented: UIViewController,
                                    presenting: UIViewController,
                                    source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return HalfModalPresentationAnimator(transitionStyle: .presentation)
    }

    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return HalfModalPresentationAnimator(transitionStyle: .dismissal)
    }

    public func presentationController(forPresented presented: UIViewController,
                                       presenting: UIViewController?,
                                       source: UIViewController) -> UIPresentationController? {
        let controller = HalfModalPresentationController(presentedViewController: presented, presenting: presenting)
        controller.delegate = self
        return controller
    }
}

extension HalfModalPresentationDelegate: UIAdaptivePresentationControllerDelegate, UIPopoverPresentationControllerDelegate {
    public func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}
