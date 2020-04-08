//
//  TestFirstViewController.swift
//  FunctionConfirm
//
//  Created by yusaku maki on 2020/03/24.
//  Copyright © 2020 牧宥作. All rights reserved.
//

import UIKit
import PanModal

final class TestFirstViewController: UIViewController {

    @IBAction private func clickButton(_ sender: Any) {
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

    static func make() -> PanModalPresentable.LayoutType {
        let storyBoard = UIStoryboard(name: "TestFirst", bundle: nil)
        let viewController: PanModalPresentable.LayoutType = storyBoard.instantiateViewController(withIdentifier: "TestFirstViewController") as! TestFirstViewController
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension TestFirstViewController: PanModalPresentable {
    var panScrollable: UIScrollView? {
        return nil
    }

    var shortFormHeight: PanModalHeight {
        return .contentHeight(300)
    }

    var longFormHeight: PanModalHeight {
        return .maxHeightWithTopInset(40)
    }

    var anchorModalToLongForm: Bool {
        return false
    }
}
