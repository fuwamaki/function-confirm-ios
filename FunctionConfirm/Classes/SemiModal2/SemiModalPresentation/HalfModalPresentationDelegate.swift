//
//  HalfModalPresentationDelegate.swift
//  FunctionConfirm
//
//  Created by yusaku maki on 2020/04/14.
//  Copyright © 2020 牧宥作. All rights reserved.
//

import UIKit

class HalfModalPresentationDelegate: NSObject, UIPopoverPresentationControllerDelegate {
    static var `default`: HalfModalPresentationDelegate = {
        return HalfModalPresentationDelegate()
    }()
}

extension HalfModalPresentationDelegate: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return HalfModalPresentationAnimator(transitionStyle: .presentation)
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return HalfModalPresentationAnimator(transitionStyle: .dismissal)
    }

    func presentationController(forPresented presented: UIViewController,
                                presenting: UIViewController?,
                                source: UIViewController) -> UIPresentationController? {
        let controller = HalfModalPresentationController(presentedViewController: presented, presenting: presenting)
        controller.delegate = self
        return controller
    }
}

extension HalfModalPresentationDelegate: UIAdaptivePresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController,
                                   traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}
