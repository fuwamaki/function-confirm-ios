//
//  StatusBar3NavigationViewController.swift
//  FunctionConfirm
//
//  Created by Maki, Yusaku | Mackey | ECID on 2019/01/23.
//  Copyright © 2019年 牧宥作. All rights reserved.
//

import UIKit

class StatusBar3NavigationViewController: UINavigationController {
    // TabBarControllerより前面にNavigationControllerがあれば、NavigationControllerのpreferredStatusBarStyleが呼ばれる
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return StatusBar3Manager.shared.statusBarStyle
    }
}
