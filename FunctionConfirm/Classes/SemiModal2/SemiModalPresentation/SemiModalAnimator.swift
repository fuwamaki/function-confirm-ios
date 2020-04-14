//
//  SemiModalAnimator.swift
//  FunctionConfirm
//
//  Created by yusaku maki on 2020/04/14.
//  Copyright © 2020 牧宥作. All rights reserved.
//

import UIKit

struct SemiModalAnimator {
    static func animate(_ animations: @escaping HalfModalPresentable.AnimationBlockType,
                        config: HalfModalPresentable?,
                        _ completion: HalfModalPresentable.AnimationCompletionType? = nil) {
        let transitionDuration = config?.transitionDuration ?? 0.5
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
