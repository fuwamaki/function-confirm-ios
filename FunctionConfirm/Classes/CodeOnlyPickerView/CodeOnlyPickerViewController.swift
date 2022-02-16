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
        let date = dateFormatter.date(from: "2022/12/12 12:12")!
        datePickerView.update(date)
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

    @objc private func doneButtonAction() {
        textField.resignFirstResponder()
    }

    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        return formatter
    }()

    private let datePickerView = CodeOnlyPickerView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupDatePicker()
    }

    func setupDatePicker() {
        datePickerView.setup(delegate: self)
        textField.inputView = datePickerView
        textField.inputAccessoryView = toolbar
    }
}

// MARK: CodeOnlyPickerViewDelegate
extension CodeOnlyPickerViewController: CodeOnlyPickerViewDelegate {
    func handleValueChanged(_ date: Date) {
        textField.text = dateFormatter.string(from: date)
    }
}
