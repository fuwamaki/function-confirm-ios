//
//  UIViewController+SemiModal.swift
//  FunctionConfirm
//
//  Created by yusaku maki on 2020/04/14.
//  Copyright © 2020 牧宥作. All rights reserved.
//

import UIKit

extension UIViewController {
    var isSemiModalPresented: Bool {
        return (transitioningDelegate as? SemiModalTransitioningDelegate) != nil
    }

    func presentSemiModal(_ viewController: SemiModalDelegate.LayoutType, sourceView: UIView? = nil, sourceRect: CGRect = .zero) {
        viewController.modalPresentationStyle = .custom
        viewController.modalPresentationCapturesStatusBarAppearance = true
        viewController.transitioningDelegate = SemiModalTransitioningDelegate.default
        present(viewController, animated: true, completion: nil)
    }
}
