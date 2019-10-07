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

    @IBOutlet private weak var favoriteButton: RoundedCornerButton!
    @IBAction private func clickFavoriteButton(_ sender: Any) {
        favoriteButton.setStatus(!favoriteButton.selectedStatus)
    }

    @IBOutlet private weak var roundedCornerButton: RoundedCornerButton!
    @IBAction private func clickRoundedCornerButton(_ sender: Any) {
        roundedCornerButton.setStatus(!roundedCornerButton.selectedStatus)
    }

    @IBOutlet private weak var heartButton: ImageButton!
    @IBAction private func clickHeartButton(_ sender: Any) {
        heartButton.selectedStatus = !heartButton.selectedStatus
    }

    @IBOutlet private weak var likeButton: ImageButton!
    @IBAction private func clickLikeButton(_ sender: Any) {
        likeButton.selectedStatus = !likeButton.selectedStatus
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
