//
//  StatusBarThirdViewController.swift
//  FunctionConfirm
//
//  Created by Maki, Yusaku | Mackey | ECID on 2019/01/22.
//  Copyright © 2019年 牧宥作. All rights reserved.
//

import UIKit

final class StatusBarThirdViewController: UIViewController {

    @IBAction func buttonTapped(_ sender: Any) {
        let viewController = StatusBarPopup2ViewController()
        tabBarController?.present(viewController, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MEMO: tabBarControllerのpresentだと戻ってきても反応しない
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//    }

    // ThirdViewController表示時&StatusBarPopup2ViewController表示に呼ばれる
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return StatusBar2Manager.shared.statusBarStyle
    }
}

extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}
