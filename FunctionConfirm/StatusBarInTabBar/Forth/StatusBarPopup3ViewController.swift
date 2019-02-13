//
//  StatusBarPopup3ViewController.swift
//  FunctionConfirm
//
//  Created by Maki, Yusaku | Mackey | ECID on 2019/01/23.
//  Copyright © 2019年 牧宥作. All rights reserved.
//

import Foundation

import UIKit

final class StatusBarPopup3ViewController: UIViewController {

    @IBAction func closeButtonTapped(_ sender: Any) {
        StatusBar3Manager.shared.statusBarStyle = .default
        setNeedsStatusBarAppearanceUpdate()
        dismiss(animated: true, completion: nil)
    }

    init() {
        super.init(nibName: "StatusBarPopup3ViewController", bundle: nil)
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .overCurrentContext
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("Please initialize programatically.")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        StatusBar3Manager.shared.statusBarStyle = .lightContent
    }
}
