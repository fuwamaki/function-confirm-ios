//
//  SegueViewController.swift
//  FunctionConfirm
//
//  Created by yusaku maki on 2021/10/20.
//  Copyright © 2021 fuwamaki. All rights reserved.
//

import UIKit

protocol SegueDelegate: AnyObject {
    func testSample(text: String?)
}

final class SegueViewController: UIViewController {

    @IBAction func clickPushButton(_ sender: Any) {
        let viewController = SegueAViewController.instantiate(delegate: self)
        navigationController?.pushViewController(viewController, animated: true)
    }

    @IBAction func clickPresentButton(_ sender: Any) {
        let viewController = SegueAViewController.instantiate(delegate: self)
        let navigationController = UINavigationController(rootViewController: viewController)
//        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)
    }

    @IBOutlet weak var textLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension SegueViewController: SegueDelegate {
    func testSample(text: String?) {
        textLabel.text = text
    }
}
