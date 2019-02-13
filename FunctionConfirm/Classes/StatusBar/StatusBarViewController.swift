//
//  StatusBarViewController.swift
//  FunctionConfirm
//
//  Created by Maki, Yusaku | Mackey | ECID on 2019/01/21.
//  Copyright © 2019年 牧宥作. All rights reserved.
//

import UIKit

final class StatusBarViewController: UIViewController {

    @IBAction func turnOverButtonTapped(_ sender: Any) {
        if view.backgroundColor == UIColor.black {
            view.backgroundColor = UIColor.white
            setStatusBarStyle(style: .default)
        } else {
            view.backgroundColor = UIColor.black
            setStatusBarStyle(style: .lightContent)
        }
    }

    @IBAction func closeButtonTapped(_ sender: Any) {
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.popViewController(animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "ステータスバーの色"
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    // StatusBarStyle
    // MEMO: Info.plistの「View controller-based status bar appearance」をYESにしておく必要がある。
    private var statusBarStyle: UIStatusBarStyle = .default
    func setStatusBarStyle(style: UIStatusBarStyle) {
        statusBarStyle = style
        self.setNeedsStatusBarAppearanceUpdate()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarStyle
    }
}
