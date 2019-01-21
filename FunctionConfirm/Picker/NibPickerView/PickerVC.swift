//
//  PickerVC.swift
//  FunctionConfirm
//
//  Created by 牧宥作 on 2018/06/22.
//  Copyright © 2018 牧宥作. All rights reserved.
//

import UIKit

class PickerVC: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    var customPickerView: CustomPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Picker動作"
        setupCustomPickerView()
        setupDoneToolBar()
    }
    
    func setupCustomPickerView() {
        customPickerView = CustomPickerView.instantiateFromNib()
        textField.inputView = customPickerView
        customPickerView.datePickerView.addTarget(self, action: #selector(PickerVC.datePickerValueChanged(sender:)), for: UIControl.Event.valueChanged)
    }
    
    func setupDoneToolBar() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let toolBarBtn = UIBarButtonItem(title: "DONE", style: .plain, target: self, action: #selector(PickerVC.doneButtonAction))
        toolBar.items = [toolBarBtn]
        textField.inputAccessoryView = toolBar
    }
    
    @IBAction func textEditingChanged(_ sender: Any) {
        // MEMO: いつのアクションなのか不明
        print("changed")
    }
    
    @IBAction func textEditingDidBegin(_ sender: Any) {
        // MEMO: InputView表示時のアクション
    }
    
    @IBAction func textEditingDidEnd(_ sender: Any) {
        // MEMO: InputViewクローズ時のアクション
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
