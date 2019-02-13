//
//  PickerView.swift
//  FunctionConfirm
//
//  Created by 牧宥作 on 2018/06/22.
//  Copyright © 2018 牧宥作. All rights reserved.
//

import UIKit

final class CustomPickerView: UIView {

    @IBOutlet weak var datePickerView: UIDatePicker!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension CustomPickerView: NibLoadable {}
