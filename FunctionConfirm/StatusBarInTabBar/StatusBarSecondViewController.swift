//
//  StatusBarSecondViewController.swift
//  FunctionConfirm
//
//  Created by Maki, Yusaku | Mackey | ECID on 2019/01/22.
//  Copyright © 2019年 牧宥作. All rights reserved.
//

import UIKit

final class StatusBarSecondViewController: UIViewController {
    
    @IBAction func buttonTapped(_ sender: Any) {
        let viewController = StatusBarPopupViewController()
        tabBarController?.present(viewController, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
