//
//  CodeOnlyPickerView.swift
//  FunctionConfirm
//
//  Created by Maki, Yusaku | Mackey | ECID on 2019/01/08.
//  Copyright © 2019年 牧宥作. All rights reserved.
//

import UIKit

final class CodeOnlyPickerView: UIView {

    var datePicker: UIDatePicker = UIDatePicker()

    override init(frame: CGRect) {
        let view = CGRect.init(x: 0, y: 0, width: 320, height: 216)
        super.init(frame: view)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func setupDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.locale = Locale.current
        datePicker.maximumDate = Date()
        addSubview(datePicker)
    }
}
