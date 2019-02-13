//
//  MVVMListTableViewCell.swift
//  FunctionConfirm
//
//  Created by Maki, Yusaku | Mackey | ECID on 2019/01/03.
//  Copyright © 2019年 牧宥作. All rights reserved.
//

import UIKit

class MVVMListTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!

    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = ""
        categoryLabel.text = ""
        priceLabel.text = ""
    }

    func render(item: ItemRx) {
        nameLabel.text = item.name
        categoryLabel.text = item.category
        priceLabel.text = String(item.price)
    }
}

extension MVVMListTableViewCell: NibLoadable {}
