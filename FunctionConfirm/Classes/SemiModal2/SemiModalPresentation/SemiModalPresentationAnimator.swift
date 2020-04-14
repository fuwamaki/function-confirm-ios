//
//  SemiModalPresentationAnimator.swift
//  FunctionConfirm
//
//  Created by yusaku maki on 2020/04/14.
//  Copyright © 2020 牧宥作. All rights reserved.
//

import UIKit

class SemiModalPresentationAnimator: NSObject {

    enum TransitionStyle {
        case present
        case dismiss

        func layoutType(context: UIViewControllerContextTransitioning) -> SemiModalDelegate.LayoutType? {
            switch self {
            case .present: return context.viewController(forKey: .to) as? SemiModalDelegate.LayoutType
            case .dismiss: return context.viewController(forKey: .from) as? SemiModalDelegate.LayoutType
            }
        }
    }

    private let transitionStyle: TransitionStyle

    required init(transitionStyle: TransitionStyle) {
        self.transitionStyle = transitionStyle
        super.init()
    }
}

// MARK: UIViewControllerAnimatedTransitioning
extension SemiModalPresentationAnimator: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        guard
            let transitionContext = transitionContext,
            let presentable = transitionStyle.layoutType(context: transitionContext)
            else { return 0.5 }
        return presentable.transitionDuration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        switch transitionStyle {
        case .present:
            animatePresentation(transitionContext: transitionContext)
        case .dismiss:
            animateDismiss(transitionContext: transitionContext)
        }
    }
}

// MARK: private
extension SemiModalPresentationAnimator {
    private func animatePresentation(transitionContext: UIViewControllerContextTransitioning) {
        guard
            let toViewController = transitionContext.viewController(forKey: .to),
            let fromViewController = transitionContext.viewController(forKey: .from),
            let layoutType = transitionStyle.layoutType(context: transitionContext)
            else { return }
        fromViewController.beginAppearanceTransition(false, animated: true)
        let semiView: UIView = transitionContext.containerView.halfContainerView ?? toViewController.view
        semiView.frame = transitionContext.finalFrame(for: toViewController)
        semiView.frame.origin.y = transitionContext.containerView.frame.height
        SemiModalAnimator.animate({
            semiView.frame.origin.y = layoutType.shortFormYPos
        }, config: layoutType, { didComplete in
            fromViewController.endAppearanceTransition()
            transitionContext.completeTransition(didComplete)
        })
    }

    private func animateDismiss(transitionContext: UIViewControllerContextTransitioning) {
        guard
            let toViewController = transitionContext.viewController(forKey: .to),
            let fromViewController = transitionContext.viewController(forKey: .from),
            let layoutType = transitionStyle.layoutType(context: transitionContext)
            else { return }
        toViewController.beginAppearanceTransition(true, animated: true)
        let semiView: UIView = transitionContext.containerView.halfContainerView ?? fromViewController.view
        SemiModalAnimator.animate({
            semiView.frame.origin.y = transitionContext.containerView.frame.height
        }, config: layoutType, { didComplete in
            fromViewController.view.removeFromSuperview()
            toViewController.endAppearanceTransition()
            transitionContext.completeTransition(didComplete)
        })
    }
}
