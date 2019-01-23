//
//  StatusBarPopup2ViewController.swift
//  FunctionConfirm
//
//  Created by Maki, Yusaku | Mackey | ECID on 2019/01/22.
//  Copyright © 2019年 牧宥作. All rights reserved.
//

import Foundation

import UIKit

final class StatusBar2Manager: NSObject {
    static let shared = StatusBar2Manager()
    var statusBarStyle: UIStatusBarStyle = .default
}






final class StatusBarPopup2ViewController: UIViewController {

    private var statusBarStyle: UIStatusBarStyle = .lightContent

    @IBAction func closeButtonTapped(_ sender: Any) {
        StatusBar2Manager.shared.statusBarStyle = .default
        setNeedsStatusBarAppearanceUpdate()
        dismiss(animated: true, completion: nil)
    }

    init() {
        super.init(nibName: "StatusBarPopup2ViewController", bundle: nil)
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .overCurrentContext
//        presentedViewController?.modalPresentationCapturesStatusBarAppearance = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("Please initialize programatically.")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        StatusBar2Manager.shared.statusBarStyle = .lightContent
//        setNeedsStatusBarAppearanceUpdate()
    }
}
