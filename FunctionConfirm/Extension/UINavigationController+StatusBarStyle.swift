//
//  UINavigationController.swift
//  FunctionConfirm
//
//  Created by Maki, Yusaku | Mackey | ECID on 2019/01/22.
//  Copyright © 2019年 牧宥作. All rights reserved.
//

import UIKit

extension UINavigationController {
    // StatusBarの色を変えられるようにするための設定
    open override var childForStatusBarStyle: UIViewController? {
        return self.visibleViewController
    }
}
