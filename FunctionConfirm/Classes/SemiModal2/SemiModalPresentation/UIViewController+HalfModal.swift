//
//  UIViewController+HalfModal.swift
//  FunctionConfirm
//
//  Created by yusaku maki on 2020/04/14.
//  Copyright © 2020 牧宥作. All rights reserved.
//

import UIKit

extension UIViewController: HalfModalPresenter {
    var isHalfModalPresented: Bool {
        return (transitioningDelegate as? HalfModalPresentationDelegate) != nil
    }

    func presentHalfModal(_ viewController: HalfModalPresentable.LayoutType, sourceView: UIView? = nil, sourceRect: CGRect = .zero) {
        viewController.modalPresentationStyle = .custom
        viewController.modalPresentationCapturesStatusBarAppearance = true
        viewController.transitioningDelegate = HalfModalPresentationDelegate.default
        present(viewController, animated: true, completion: nil)
    }
}
