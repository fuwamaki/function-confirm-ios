//
//  SemiModalAnimator.swift
//  FunctionConfirm
//
//  Created by yusaku maki on 2020/04/14.
//  Copyright © 2020 牧宥作. All rights reserved.
//

import UIKit

struct SemiModalAnimator {
    static func animate(_ animations: @escaping SemiModalDelegate.AnimationBlockType,
                        semiModalDelegate: SemiModalDelegate,
                        _ completion: SemiModalDelegate.AnimationCompletionType? = nil) {
        UIView.animate(withDuration: semiModalDelegate.transitionDuration,
                       delay: 0,
                       usingSpringWithDamping: semiModalDelegate.springDamping,
                       initialSpringVelocity: 0,
                       options: semiModalDelegate.transitionAnimationOptions,
                       animations: animations,
                       completion: completion)
    }
}
