//
//  TestFirstViewController.swift
//  FunctionConfirm
//
//  Created by yusaku maki on 2020/03/24.
//  Copyright © 2020 牧宥作. All rights reserved.
//

import UIKit

final class TestFirstViewController: UIViewController {

    @IBAction func clickButton(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "TestSecond", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "TestSecondViewController")
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .fullScreen
        let transition = CATransition()
        transition.duration = 0.4
        transition.type = .push
        transition.subtype = .fromRight
        view.window!.layer.add(transition, forKey: kCATransition)
        present(navigationController, animated: false, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
