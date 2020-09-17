//
//  AlarmPickerView.swift
//  FunctionConfirm
//
//  Created by yusaku maki on 2020/09/17.
//  Copyright © 2020 牧宥作. All rights reserved.
//

import UIKit

final class AlarmPickerView: UIView {

    var datePicker: UIDatePicker = UIDatePicker()

    override init(frame: CGRect) {
        let view = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 216)
        super.init(frame: view)
        setupDatePicker()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func setupDatePicker() {
        datePicker.datePickerMode = .time
        datePicker.locale = Locale(identifier: "ja")
        datePicker.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 216)
        addSubview(datePicker)
        datePicker.topAnchor.constraint(equalTo: self.topAnchor, constant: 0.0).isActive = true
        datePicker.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0.0).isActive = true
        datePicker.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0.0).isActive = true
        datePicker.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0.0).isActive = true
    }
}
