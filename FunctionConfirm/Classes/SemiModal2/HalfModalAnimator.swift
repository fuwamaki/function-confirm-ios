//
//  HalfModalAnimator.swift
//  FunctionConfirm
//
//  Created by yusaku maki on 2020/04/14.
//  Copyright © 2020 牧宥作. All rights reserved.
//

import UIKit

struct HalfModalAnimator {

    struct Constants {
        static let defaultTransitionDuration: TimeInterval = 0.5
    }

    static func animate(_ animations: @escaping HalfModalPresentable.AnimationBlockType,
                        config: HalfModalPresentable?,
                        _ completion: HalfModalPresentable.AnimationCompletionType? = nil) {
        let transitionDuration = config?.transitionDuration ?? Constants.defaultTransitionDuration
        let springDamping = config?.springDamping ?? 1.0
        let animationOptions = config?.transitionAnimationOptions ?? []
        UIView.animate(withDuration: transitionDuration,
                       delay: 0,
                       usingSpringWithDamping: springDamping,
                       initialSpringVelocity: 0,
                       options: animationOptions,
                       animations: animations,
                       completion: completion)
    }
}
