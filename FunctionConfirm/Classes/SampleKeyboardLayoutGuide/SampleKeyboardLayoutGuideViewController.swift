//
//  SampleKeyboardLayoutGuideViewController.swift
//  FunctionConfirm
//
//  Created by yusaku maki on 2021/06/18.
//  Copyright © 2021 fuwamaki. All rights reserved.
//

import UIKit

final class SampleKeyboardLayoutGuideViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var textField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
//        view.keyboardLayoutGuide.topAnchor
//            .constraint(equalTo: scrollView.bottomAnchor)
//            .isActive = true

//        NotificationCenter.default.addObserver(
//            self,
//            selector: #selector(self.showKeyboard(_:)),
//            name: UIResponder.keyboardWillShowNotification,
//            object: nil)
//        NotificationCenter.default.addObserver(
//            self,
//            selector: #selector(self.hideKeyboard(_:)),
//            name: UIResponder.keyboardWillHideNotification,
//            object: nil)

        let tapGestureRecognizer = UITapGestureRecognizer(
            target: self, action: #selector(tapBackground(_:)))
        view.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer.cancelsTouchesInView = false
        tapGestureRecognizer.delegate = self
    }
}

// MARK: UIGestureRecognizerDelegate
extension SampleKeyboardLayoutGuideViewController: UIGestureRecognizerDelegate {
    @objc private func tapBackground(_ sender: AnyObject) {
        view.endEditing(true)
    }
}

// MARK: Keyboard
extension SampleKeyboardLayoutGuideViewController {
    @objc private func showKeyboard(_ notification: Foundation.Notification) {
        guard let userInfo = (notification as NSNotification).userInfo,
              let keyboard = userInfo[UIResponder.keyboardFrameEndUserInfoKey]
                as? NSValue else { return }
        let keyboardHeight = keyboard.cgRectValue.height
        scrollView.contentInset.bottom = keyboardHeight
    }

    @objc private func hideKeyboard(_ notification: Foundation.Notification) {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }
}
