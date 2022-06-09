//
//  TestChildViewController.swift
//  FunctionConfirm
//
//  Created by fuwamaki on 2022/06/09.
//  Copyright © 2022 fuwamaki. All rights reserved.
//

import UIKit

final class TestChildViewController: UIViewController {
    @IBOutlet private weak var testLabel: UILabel!

    static func make(text: String) -> TestChildViewController {
        let storyBoard = UIStoryboard(name: "NewPageControl", bundle: nil)
        let viewController = storyBoard.instantiateViewController(
            withIdentifier: "TestChildViewController"
        ) as! TestChildViewController
        viewController.text = text
        return viewController
    }

    private var text: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        testLabel.text = text
    }
}
