//
//  DismissAnimator.swift
//  FunctionConfirm
//
//  Created by yusaku maki on 2020/04/06.
//  Copyright © 2020 牧宥作. All rights reserved.
//

import UIKit

class DismissAnimator: NSObject {}

extension DismissAnimator: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from) else { return }
        let containerView = transitionContext.containerView
        containerView.addSubview(fromVC.view)
        let finalFrame = CGRect(origin: CGPoint(x: 0, y: UIScreen.main.bounds.height), size: UIScreen.main.bounds.size)
        let option: UIView.AnimationOptions = transitionContext.isInteractive ? .curveLinear : .curveEaseIn
        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            delay: 0,
            options: [option],
            animations: {
                fromVC.view.frame = finalFrame },
            completion: { _ in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled) })
    }
}
