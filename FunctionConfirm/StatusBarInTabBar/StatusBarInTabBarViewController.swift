//
//  StatusBarInTabBarViewController.swift
//  FunctionConfirm
//
//  Created by Maki, Yusaku | Mackey | ECID on 2019/01/22.
//  Copyright © 2019年 牧宥作. All rights reserved.
//

import UIKit

final class StatusBarInTabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "ステータスバーの色(TabBar)"
    }
}

// コレつけるとダメっぽい...
//extension UITabBarController {
//    open override var childForStatusBarStyle: UIViewController? {
//        return self.children.first
//    }
//}
