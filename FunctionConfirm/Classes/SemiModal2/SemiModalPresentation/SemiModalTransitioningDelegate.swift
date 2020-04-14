//
//  SemiModalTransitioningDelegate.swift
//  FunctionConfirm
//
//  Created by yusaku maki on 2020/04/14.
//  Copyright © 2020 牧宥作. All rights reserved.
//

import UIKit

class SemiModalTransitioningDelegate: NSObject, UIPopoverPresentationControllerDelegate {
    static var `default`: SemiModalTransitioningDelegate = {
        return SemiModalTransitioningDelegate()
    }()
}

// MARK: UIViewControllerTransitioningDelegate
extension SemiModalTransitioningDelegate: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SemiModalPresentationAnimator(transitionStyle: .present)
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SemiModalPresentationAnimator(transitionStyle: .dismiss)
    }

    func presentationController(forPresented presented: UIViewController,
                                presenting: UIViewController?,
                                source: UIViewController) -> UIPresentationController? {
        let controller = HalfModalPresentationController(presentedViewController: presented, presenting: presenting)
        controller.delegate = self
        return controller
    }
}

// MARK: UIAdaptivePresentationControllerDelegate
extension SemiModalTransitioningDelegate: UIAdaptivePresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController,
                                   traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}
