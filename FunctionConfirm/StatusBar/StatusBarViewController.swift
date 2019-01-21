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
        } else {
            view.backgroundColor = UIColor.black
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "ステータスバーの色"
    }
}
