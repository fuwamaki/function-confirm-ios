//
//  PasteSampleViewController.swift
//  FunctionConfirm
//
//  Created by fuwamaki on 2022/06/09.
//  Copyright © 2022 fuwamaki. All rights reserved.
//

import UIKit

final class PasteSampleViewController: UIViewController {
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var pasteControl: UIPasteControl!

    @IBAction private func clickSampleCopyButton(_ sender: UIButton) {
        UIPasteboard.general.string = "Sample"
    }

    @IBAction private func clickPasteButton(_ sender: UIButton) {
        textField.text = UIPasteboard.general.string
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
