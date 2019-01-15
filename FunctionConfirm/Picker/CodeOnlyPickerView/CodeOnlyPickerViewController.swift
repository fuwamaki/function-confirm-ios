//
//  CodeOnlyPickerViewController.swift
//  FunctionConfirm
//
//  Created by Maki, Yusaku | Mackey | ECID on 2019/01/08.
//  Copyright © 2019年 牧宥作. All rights reserved.
//

import UIKit

final class CodeOnlyPickerViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Picker動作"
        setupDatePicker()
        setupDoneToolBar()
    }

    func setupDatePicker() {
        let datePickerView = CodeOnlyPickerView()
        textField.inputView = datePickerView
        datePickerView.datePicker.addTarget(self, action: #selector(PickerVC.datePickerValueChanged(sender:)), for: UIControlEvents.valueChanged)
    }

    func setupDoneToolBar() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let toolBarBtn = UIBarButtonItem(title: "DONE", style: .plain, target: self, action: #selector(PickerVC.doneButtonAction))
        toolBar.items = [toolBarBtn]
        textField.inputAccessoryView = toolBar
    }

    @objc func datePickerValueChanged(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat  = "yyyy/MM/dd";
        textField.text = dateFormatter.string(from: sender.date)
    }

    @objc func doneButtonAction(){
        textField.resignFirstResponder()
    }
}
