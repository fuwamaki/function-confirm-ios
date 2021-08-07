//
//  MediumRootViewController.swift
//  FunctionConfirm
//
//  Created by yusaku maki on 2021/06/18.
//  Copyright © 2021 fuwamaki. All rights reserved.
//

import UIKit
import PhotosUI

final class MediumRootViewController: UIViewController {

    @IBAction func clickButton(_ sender: Any) {
        showImagePicker()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // TODO: Xcode13 betaでは実装できないよう。更新まで待つ。
    func showImagePicker() {
        let configuration = PHPickerConfiguration()
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        if let sheet = picker.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
        }
        present(picker, animated: true)
    }
}

// MARK: PHPickerViewControllerDelegate
extension MediumRootViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true, completion: nil)
    }
}
