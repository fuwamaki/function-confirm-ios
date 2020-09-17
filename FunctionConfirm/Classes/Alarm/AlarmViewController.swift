//
//  AlarmViewController.swift
//  FunctionConfirm
//
//  Created by yusaku maki on 2020/09/17.
//  Copyright © 2020 牧宥作. All rights reserved.
//

import UIKit

final class AlarmViewController: UIViewController {

    @IBOutlet weak var dateTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupDatePicker()
        setupDoneToolBar()
    }

    func setupDatePicker() {
        let datePickerView = AlarmPickerView()
        dateTextField.inputView = datePickerView
        datePickerView.datePicker.addTarget(self, action: #selector(datePickerValueChanged(sender:)), for: UIControl.Event.valueChanged)
    }

    func setupDoneToolBar() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let toolBarBtn = UIBarButtonItem(title: "DONE", style: .plain, target: self, action: #selector(doneButtonAction))
        toolBar.items = [toolBarBtn]
        dateTextField.inputAccessoryView = toolBar
    }

    @objc func datePickerValueChanged(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateTextField.text = dateFormatter.string(from: sender.date)
    }

    @objc func doneButtonAction() {
        dateTextField.resignFirstResponder()
    }
}
