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
    @IBOutlet weak var textField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.keyboardLayoutGuide.topAnchor
            .constraint(equalToSystemSpacingBelow: scrollView.bottomAnchor, multiplier: 1.0)
            .isActive = true
    }
}
