//
//  StatusBarPopupViewController.swift
//  FunctionConfirm
//
//  Created by Maki, Yusaku | Mackey | ECID on 2019/01/22.
//  Copyright © 2019年 牧宥作. All rights reserved.
//

import UIKit

final class StatusBarPopupViewController: UIViewController {

    private weak var delegate: StatusBarSecondDelegate?

    @IBAction func closeButtonTapped(_ sender: Any) {
        delegate?.setStatusBarStyle(style: .default)
        dismiss(animated: true, completion: nil)
    }

    init(delegate: StatusBarSecondDelegate) {
        self.delegate = delegate
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
}
