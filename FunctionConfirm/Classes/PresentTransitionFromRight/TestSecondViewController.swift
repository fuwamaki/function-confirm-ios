//
//  TestSecondViewController.swift
//  FunctionConfirm
//
//  Created by yusaku maki on 2020/03/24.
//  Copyright © 2020 牧宥作. All rights reserved.
//

import UIKit

final class TestSecondViewController: UIViewController {

    @objc private func clickBackBarButtonItem() {
        let transition = CATransition()
        transition.duration = 0.4
        transition.type = .push
        transition.subtype = .fromLeft
        view.window!.layer.add(transition, forKey: kCATransition)
        dismiss(animated: false, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    private func setupViews() {
        let backBarButtonItem = UIBarButtonItem(title: "戻る", style: .plain, target: self, action: #selector(clickBackBarButtonItem))
        navigationItem.setLeftBarButton(backBarButtonItem, animated: true)
    }
}
