//
//  StatusBarForthViewController.swift
//  FunctionConfirm
//
//  Created by Maki, Yusaku | Mackey | ECID on 2019/01/23.
//  Copyright © 2019年 牧宥作. All rights reserved.
//

import Foundation

import UIKit

final class StatusBarForthViewController: UIViewController {

    @IBAction func buttonTapped(_ sender: Any) {
        let viewController = StatusBarPopup2ViewController()
        tabBarController?.present(viewController, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return StatusBar2Manager.shared.statusBarStyle
    }
}
