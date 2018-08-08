//
//  MVPTableCell.swift
//  FunctionConfirm
//
//  Created by Maki, Yusaku | Mackey | ECID on 8/8/18.
//  Copyright © 2018 牧宥作. All rights reserved.
//

import UIKit

final class MVPTableCell: UITableViewCell {

    private var priceLabel: UILabel

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        priceLabel = UILabel(frame: CGRect.zero)
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        priceLabel = UILabel(frame: CGRect.zero)
        super.init(coder: aDecoder)
        setupView()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        priceLabel.frame = CGRect(x: bounds.size.width - 56, y: 0, width: bounds.size.width - 16, height: bounds.size.height)
    }

    private func setupView() {
        priceLabel.font = UIFont.systemFont(ofSize: 14.0)
        priceLabel.textColor = UIColor.black
        addSubview(priceLabel)
    }

    func setItem() {
        // TODO: Item情報を入れる
        textLabel?.text = "もふもふ"
        detailTextLabel?.text = "神様、僕は気付いてしまった"
        priceLabel.text = "2000円"
    }
}
