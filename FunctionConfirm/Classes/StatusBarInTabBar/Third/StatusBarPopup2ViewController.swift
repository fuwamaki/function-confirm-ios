//
//  StatusBarPopup2ViewController.swift
//  FunctionConfirm
//
//  Created by Maki, Yusaku | Mackey | ECID on 2019/01/22.
//  Copyright © 2019年 牧宥作. All rights reserved.
//

import UIKit

final class StatusBarPopup2ViewController: UIViewController {

    @IBAction func closeButtonTapped(_ sender: Any) {
        StatusBar2Manager.shared.statusBarStyle = .default
        setNeedsStatusBarAppearanceUpdate()
        dismiss(animated: true, completion: nil)
    }

    init() {
        super.init(nibName: "StatusBarPopup2ViewController", bundle: nil)
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .overCurrentContext
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("Please initialize programatically.")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        StatusBar2Manager.shared.statusBarStyle = .lightContent
        // MEMO: StatusBarPopup2ViewController表示時にsetNeedsStatusBarAppearanceUpdateが動作するのでわざわざ指定する必要はない
    }
}
