//
//  SemiModalPresentationController.swift
//  FunctionConfirm
//
//  Created by yusaku maki on 2020/04/06.
//  Copyright © 2020 牧宥作. All rights reserved.
//

import UIKit

private struct Constant {
    static let overlayBackgroundColor: UIColor = .black
    static let overlayBackgroundAlpha: CGFloat = 0.5
}

final class SemiModalPresentationController: UIPresentationController {

    private let overlayView = UIView()

    /// presentアニメーション時に暗い背景Viewを裏側に設置
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        overlayView.frame = containerView!.bounds
        overlayView.backgroundColor = Constant.overlayBackgroundColor
        overlayView.alpha = 0.0
        containerView?.insertSubview(overlayView, at: 0)
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [unowned self] _ in
            self.overlayView.alpha = Constant.overlayBackgroundAlpha
        })
    }

    /// dismissアニメーション時に暗い背景Viewを透明に
    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [unowned self] _ in
            self.overlayView.alpha = 0.0
        })
    }

    /// dismiss完了時に暗い背景Viewを取り除く
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        super.dismissalTransitionDidEnd(completed)
        if completed {
            overlayView.removeFromSuperview()
        }
    }

    override var frameOfPresentedViewInContainerView: CGRect {
        return containerView!.bounds
    }

    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        overlayView.frame = containerView!.bounds
        presentedView!.frame = frameOfPresentedViewInContainerView
    }
}
