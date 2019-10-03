//
//  RoundedCornerViewController.swift
//  FunctionConfirm
//
//  Created by Maki, Yusaku | Mackey | ECID on 2019/02/14.
//  Copyright © 2019年 牧宥作. All rights reserved.
//

import UIKit

final class RoundedCornerViewController: UIViewController {

    @IBOutlet private weak var label: UILabel!
    @IBOutlet private weak var button: UIButton!
    @IBOutlet private weak var roundedCornerButton: RoundedCornerButton!
    @IBAction private func clickRoundedCornerButton(_ sender: Any) {
        roundedCornerButton.setStatus(!roundedCornerButton.selectedStatus)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "角丸"
    }

    override func updateViewConstraints() {
        // iOS11以降のみ角丸になる
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        super.updateViewConstraints()
    }
}
