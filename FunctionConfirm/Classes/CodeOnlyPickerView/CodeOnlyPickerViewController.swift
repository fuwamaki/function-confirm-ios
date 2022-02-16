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

    override func viewDidLoad() {
        super.viewDidLoad()
        setupDatePicker()
    }

    func setupDatePicker() {
        let datePickerView = CodeOnlyPickerView()
        datePickerView.setup(delegate: self)
        textField.inputView = datePickerView
        textField.inputAccessoryView = toolbar
    }

    @objc private func doneButtonAction() {
        textField.resignFirstResponder()
    }
}

// MARK: CodeOnlyPickerViewDelegate
extension CodeOnlyPickerViewController: CodeOnlyPickerViewDelegate {
    func handleValueChanged(_ date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
        textField.text = dateFormatter.string(from: date)
    }
}
