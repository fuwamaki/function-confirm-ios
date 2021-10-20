//
//  SegueAViewController.swift
//  FunctionConfirm
//
//  Created by yusaku maki on 2021/10/20.
//  Copyright © 2021 fuwamaki. All rights reserved.
//

import UIKit

final class SegueAViewController: UIViewController {

    @IBOutlet private weak var inputTextField: UITextField!

    static func instantiate() -> SegueAViewController {
        let storyBoard = UIStoryboard(name: "SegueA", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "SegueAViewController") as! SegueAViewController
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
