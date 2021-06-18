//
//  StatusBarSecondViewController.swift
//  FunctionConfirm
//
//  Created by Maki, Yusaku | Mackey | ECID on 2019/01/22.
//  Copyright © 2019年 牧宥作. All rights reserved.
//

import UIKit

protocol StatusBarSecondDelegate: AnyObject {
    func setStatusBarStyle(style: UIStatusBarStyle)
}

final class StatusBarSecondViewController: UIViewController {

    private var statusBarStyle: UIStatusBarStyle = .default

    @IBAction func buttonTapped(_ sender: Any) {
        setStatusBarStyle(style: .lightContent)
        let viewController = StatusBarPopupViewController(delegate: self)
        tabBarController?.present(viewController, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarStyle
    }
}

extension StatusBarSecondViewController: StatusBarSecondDelegate {
    // StatusBarStyle
    // MEMO: Info.plistの「View controller-based status bar appearance」をYESにしておく必要がある。
    // MEMO: UINavigationControllerのextensionで、chilForStatusBarStyleを設定しておく必要がある。
    func setStatusBarStyle(style: UIStatusBarStyle) {
        statusBarStyle = style
        self.setNeedsStatusBarAppearanceUpdate()
    }
}
