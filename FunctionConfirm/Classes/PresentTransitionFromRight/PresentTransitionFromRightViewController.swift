//
//  PresentTransitionFromRightViewController.swift
//  FunctionConfirm
//
//  Created by yusaku maki on 2020/03/24.
//  Copyright © 2020 牧宥作. All rights reserved.
//

import UIKit

final class PresentTransitionFromRightViewController: UIViewController {

    @IBAction private func clickShowModalButton(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "TestFirst", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "TestFirstViewController")
        let navigationController = UINavigationController(rootViewController: viewController)
        present(navigationController, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
