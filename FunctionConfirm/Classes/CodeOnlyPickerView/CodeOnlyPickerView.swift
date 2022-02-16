//
//  CodeOnlyPickerView.swift
//  FunctionConfirm
//
//  Created by Maki, Yusaku | Mackey | ECID on 2019/01/08.
//  Copyright © 2019年 牧宥作. All rights reserved.
//

import UIKit

protocol CodeOnlyPickerViewDelegate: AnyObject {
    func handleValueChanged(_ date: Date)
}

final class CodeOnlyPickerView: UIView {

    private weak var delegate: CodeOnlyPickerViewDelegate?

    private lazy var datePicker: UIDatePicker = {
        var picker = UIDatePicker()
        picker.datePickerMode = .dateAndTime
        picker.locale = Locale(identifier: "ja")
        picker.minimumDate = Date()
        picker.preferredDatePickerStyle = .wheels
        picker.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 216)
        picker.addTarget(
            self,
            action: #selector(datePickerValueChanged(sender:)),
            for: UIControl.Event.valueChanged
        )
        return picker
    }()

    @objc private func datePickerValueChanged(sender: UIDatePicker) {
        delegate?.handleValueChanged(sender.date)
    }

    override init(frame: CGRect) {
        let view = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 216)
        super.init(frame: view)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func setup(delegate: CodeOnlyPickerViewDelegate) {
        self.delegate = delegate
        addSubview(datePicker)
        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: self.topAnchor),
            datePicker.leftAnchor.constraint(equalTo: self.leftAnchor),
            datePicker.rightAnchor.constraint(equalTo: self.rightAnchor),
            datePicker.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }

    func update(_ date: Date) {
        datePicker.date = date
    }
}
