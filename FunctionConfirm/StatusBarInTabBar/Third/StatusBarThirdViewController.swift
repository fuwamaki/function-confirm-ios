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
