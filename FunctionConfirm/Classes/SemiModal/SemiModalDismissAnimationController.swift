//
//  SemiModalDismissAnimationController.swift
//  FunctionConfirm
//
//  Created by yusaku maki on 2020/04/06.
//  Copyright © 2020 牧宥作. All rights reserved.
//

import UIKit

private struct Constant {
    static let dismissTransitionDelay: TimeInterval = 0.4
}

class SemiModalDismissAnimationController: NSObject {}

// MARK: UIViewControllerAnimatedTransitioning
extension SemiModalDismissAnimationController: UIViewControllerAnimatedTransitioning {
    /// アニメーション時間を定義
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return Constant.dismissTransitionDelay
    }

    /// アニメーションの具体的内容を定義
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewController(forKey: .from) else { return }
        let containerView = transitionContext.containerView
        containerView.addSubview(fromViewController.view)
        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            delay: 0,
            options: [transitionContext.isInteractive ? .curveLinear : .curveEaseIn],
            animations: {
                fromViewController.view.frame = CGRect(origin: CGPoint(x: 0, y: UIScreen.main.bounds.height), size: UIScreen.main.bounds.size) },
            completion: { _ in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled) })
    }
}
