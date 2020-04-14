//
//  HalfModalRootViewController.swift
//  FunctionConfirm
//
//  Created by yusaku maki on 2020/04/14.
//  Copyright © 2020 牧宥作. All rights reserved.
//

import UIKit

final class HalfModalRootViewController: UIViewController {

    @IBAction private func clickShowModalButton(_ sender: Any) {
        let viewController = HalfModalViewController.make()
        presentHalfModal(viewController)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
