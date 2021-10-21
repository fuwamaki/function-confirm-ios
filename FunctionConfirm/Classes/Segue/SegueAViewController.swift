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

    static func instantiate(delegate: SegueDelegate) -> SegueAViewController {
        let storyBoard = UIStoryboard(name: "SegueA", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "SegueAViewController") as! SegueAViewController
        viewController.delegate = delegate
        return viewController
    }

    private weak var delegate: SegueDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.delegate = self
//        navigationItem.rightBarButtonItem = UIBarButtonItem(
//            title: "閉じる",
//            style: .plain,
//            target: self,
//            action: #selector(close(_:)))
//        navigationItem.hidesBackButton = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }

//    @objc func close(_ sender: UIBarButtonItem) {
//        dismiss(animated: true, completion: nil)
//    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.testSample(text: inputTextField.text)
//        if let viewController = self.presentingViewController as? SegueViewController {
//            viewController.testSample(text: inputTextField.text)
//        }
    }
}

extension SegueAViewController: UINavigationControllerDelegate {
    func navigationController(
        _ navigationController: UINavigationController,
        willShow viewController: UIViewController,
        animated: Bool
    ) {
//        if viewController is SegueViewController {
//            delegate?.testSample(text: inputTextField.text)
//        }
    }
}
