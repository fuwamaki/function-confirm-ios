//
//  StatusBarPopupViewController.swift
//  FunctionConfirm
//
//  Created by Maki, Yusaku | Mackey | ECID on 2019/01/22.
//  Copyright © 2019年 牧宥作. All rights reserved.
//

import UIKit

final class StatusBarPopupViewController: UIViewController {

    @IBAction func closeButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    init() {
        super.init(nibName: "StatusBarPopupViewController", bundle: nil)
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .overCurrentContext
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Please initialize programatically.")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //反応しない者たち
//        setStatusBarStyle(style: .lightContent)
//        UIApplication.shared.statusBarStyle = .lightContent
    }

    private var statusBarStyle: UIStatusBarStyle = .default
    func setStatusBarStyle(style: UIStatusBarStyle) {
        statusBarStyle = style
        self.setNeedsStatusBarAppearanceUpdate()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarStyle
    }
}
