//
//  AlarmViewController.swift
//  FunctionConfirm
//
//  Created by yusaku maki on 2020/09/17.
//  Copyright © 2020 牧宥作. All rights reserved.
//

import UIKit
import ImageViewer_swift

final class AlarmViewController: UIViewController {

    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!

    @IBAction func clickAlarmButton(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
        let todayDateFormatter = DateFormatter()
        todayDateFormatter.dateFormat = "yyyy/MM/dd"
        let aaa = todayDateFormatter.string(from: Date())
        alarm.selectedWakeUpTime = dateFormatter.date(from: aaa + " " + dateTextField.text!)
        alarm.runTimer()
    }

    private var alarm = Alarm()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupDatePicker()
        setupDoneToolBar()
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(didTap(_:)))
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
    }
    @objc private func didTap(_ sender: UITapGestureRecognizer) {
        imageView.setupImageViewer()
    }
}

// MARK: DatePicker
extension AlarmViewController {
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
