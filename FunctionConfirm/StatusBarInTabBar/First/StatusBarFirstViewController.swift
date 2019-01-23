//
//  StatusBarFirstViewController.swift
//  FunctionConfirm
//
//  Created by Maki, Yusaku | Mackey | ECID on 2019/01/22.
//  Copyright © 2019年 牧宥作. All rights reserved.
//

import UIKit

final class StatusBarFirstViewController: UIViewController {

    @IBAction func turnOverButtonTapped(_ sender: Any) {
        if view.backgroundColor == UIColor.black {
            view.backgroundColor = UIColor.white
            setStatusBarStyle(style: .default)
        } else {
            view.backgroundColor = UIColor.black
            setStatusBarStyle(style: .lightContent)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // StatusBarStyle
    // MEMO: Info.plistの「View controller-based status bar appearance」をYESにしておく必要がある。
    // MEMO: UINavigationControllerのextensionで、chilForStatusBarStyleを設定しておく必要がある。
    private var statusBarStyle: UIStatusBarStyle = .default
    func setStatusBarStyle(style: UIStatusBarStyle) {
        statusBarStyle = style
        self.setNeedsStatusBarAppearanceUpdate()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarStyle
    }
}
