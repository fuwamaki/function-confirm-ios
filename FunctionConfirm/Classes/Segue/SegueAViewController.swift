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
        navigationController?.delegate = self
    }

//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        if let viewController = self.presentingViewController as? SegueViewController {
//            viewController.testSample(text: inputTextField.text)
//        }
//    }
}

extension SegueAViewController: UINavigationControllerDelegate {
    func navigationController(
        _ navigationController: UINavigationController,
        willShow viewController: UIViewController,
        animated: Bool
    ) {
        if let viewController = viewController as? SegueViewController {
            viewController.testSample(text: inputTextField.text)
        }
    }
}
