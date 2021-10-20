//
//  SegueViewController.swift
//  FunctionConfirm
//
//  Created by yusaku maki on 2021/10/20.
//  Copyright © 2021 fuwamaki. All rights reserved.
//

import UIKit

final class SegueViewController: UIViewController {

    @IBAction func clickPushButton(_ sender: Any) {
        let viewController = SegueAViewController.instantiate()
        navigationController?.pushViewController(viewController, animated: true)
    }

    @IBAction func clickPresentButton(_ sender: Any) {
        let viewController = SegueAViewController.instantiate()
        let navigationController = UINavigationController(rootViewController: viewController)
        present(navigationController, animated: true, completion: nil)
    }

    @IBOutlet weak var textLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension SegueViewController {
    func testSample(text: String?) {
        textLabel.text = text
    }
}
