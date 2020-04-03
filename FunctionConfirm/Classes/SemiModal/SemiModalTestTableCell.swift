//
//  SemiModalTestTableCell.swift
//  FunctionConfirm
//
//  Created by yusaku maki on 2020/04/03.
//  Copyright © 2020 牧宥作. All rights reserved.
//

import UIKit

final class SemiModalTestTableCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func render(text: String) {
        textLabel?.text = text
    }
}
