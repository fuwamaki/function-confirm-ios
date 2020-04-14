//
//  HalfModalPresentationAnimator.swift
//  FunctionConfirm
//
//  Created by yusaku maki on 2020/04/14.
//  Copyright © 2020 牧宥作. All rights reserved.
//

import UIKit

public class HalfModalPresentationAnimator: NSObject {

    public enum TransitionStyle {
        case presentation
        case dismissal
    }

    private let transitionStyle: TransitionStyle
    private var feedbackGenerator: UISelectionFeedbackGenerator?

    required public init(transitionStyle: TransitionStyle) {
        self.transitionStyle = transitionStyle
        super.init()
        if case .presentation = transitionStyle {
            feedbackGenerator = UISelectionFeedbackGenerator()
            feedbackGenerator?.prepare()
        }
    }

    private func animatePresentation(transitionContext: UIViewControllerContextTransitioning) {
        guard
            let toVC = transitionContext.viewController(forKey: .to),
            let fromVC = transitionContext.viewController(forKey: .from)
            else { return }
        let presentable = halfModalLayoutType(from: transitionContext)
        fromVC.beginAppearanceTransition(false, animated: true)
        let yPos: CGFloat = presentable?.shortFormYPos ?? 0.0
        let halfView: UIView = transitionContext.containerView.halfContainerView ?? toVC.view
        halfView.frame = transitionContext.finalFrame(for: toVC)
        halfView.frame.origin.y = transitionContext.containerView.frame.height
        if presentable?.isHapticFeedbackEnabled == true {
            feedbackGenerator?.selectionChanged()
        }
        HalfModalAnimator.animate({
            halfView.frame.origin.y = yPos
        }, config: presentable, { [weak self] didComplete in
            fromVC.endAppearanceTransition()
            transitionContext.completeTransition(didComplete)
            self?.feedbackGenerator = nil
        })
    }

    private func animateDismissal(transitionContext: UIViewControllerContextTransitioning) {
        guard
            let toVC = transitionContext.viewController(forKey: .to),
            let fromVC = transitionContext.viewController(forKey: .from)
            else { return }
        toVC.beginAppearanceTransition(true, animated: true)
        let presentable = halfModalLayoutType(from: transitionContext)
        let halfView: UIView = transitionContext.containerView.halfContainerView ?? fromVC.view
        HalfModalAnimator.animate({
            halfView.frame.origin.y = transitionContext.containerView.frame.height
        }, config: presentable, { didComplete in
            fromVC.view.removeFromSuperview()
            toVC.endAppearanceTransition()
            transitionContext.completeTransition(didComplete)
        })
    }

    private func halfModalLayoutType(from context: UIViewControllerContextTransitioning) -> HalfModalPresentable.LayoutType? {
        switch transitionStyle {
        case .presentation:
            return context.viewController(forKey: .to) as? HalfModalPresentable.LayoutType
        case .dismissal:
            return context.viewController(forKey: .from) as? HalfModalPresentable.LayoutType
        }
    }
}

// MARK: - UIViewControllerAnimatedTransitioning Delegate
extension HalfModalPresentationAnimator: UIViewControllerAnimatedTransitioning {
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        guard
            let context = transitionContext,
            let presentable = halfModalLayoutType(from: context)
            else { return 0.5 }
        return presentable.transitionDuration
    }

    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        switch transitionStyle {
        case .presentation:
            animatePresentation(transitionContext: transitionContext)
        case .dismissal:
            animateDismissal(transitionContext: transitionContext)
        }
    }
}
