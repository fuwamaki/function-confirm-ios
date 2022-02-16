//
//  CodeOnlyPickerViewController.swift
//  FunctionConfirm
//
//  Created by Maki, Yusaku | Mackey | ECID on 2019/01/08.
//  Copyright © 2019年 牧宥作. All rights reserved.
//

import UIKit

final class CodeOnlyPickerViewController: UIViewController {

    @IBOutlet private weak var textField: UITextField!
    @IBAction private func clickUpdateButton(_ sender: Any) {
    }

    private lazy var toolbar: UIToolbar = {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let toolbarButton = UIBarButtonItem(
            title: "Done",
            style: .plain,
            target: self,
            action: #selector(doneButtonAction)
        )
        toolbar.items = [space, toolbarButton]
        return toolbar
    }()

    @objc private func datePickerValueChanged(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        textField.text = dateFormatter.string(from: sender.date)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupDatePicker()
    }

    func setupDatePicker() {
        let datePickerView = CodeOnlyPickerView()
        textField.inputView = datePickerView
        textField.inputAccessoryView = toolbar
        datePickerView.datePicker.addTarget(
            self,
            action: #selector(datePickerValueChanged(sender:)),
            for: UIControl.Event.valueChanged
        )
    }

    @objc private func doneButtonAction() {
        textField.resignFirstResponder()
    }
}
