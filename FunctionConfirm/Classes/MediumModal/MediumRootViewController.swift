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
        if let sheet = phpickerViewController.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
        }
        present(phpickerViewController, animated: true)
    }

    private lazy var phpickerViewController: PHPickerViewController = {
        let configuration = PHPickerConfiguration()
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        return picker
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: PHPickerViewControllerDelegate
extension MediumRootViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true, completion: nil)
    }
}
