//
//  PresentTransitionFromRightViewController.swift
//  FunctionConfirm
//
//  Created by yusaku maki on 2020/03/24.
//  Copyright © 2020 牧宥作. All rights reserved.
//

import UIKit
import PanModal

final class PresentTransitionFromRightViewController: UIViewController {

    @IBAction private func clickShowModalButton(_ sender: Any) {
        let viewController = TestFirstViewController.make()
        present(viewController, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
