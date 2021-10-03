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

    @IBOutlet private weak var imageView: UIImageView!

    @IBAction func clickButton(_ sender: Any) {
//        if let sheet = phpickerViewController.sheetPresentationController {
//            sheet.detents = [.medium(), .large()]
//            sheet.prefersGrabberVisible = true
//            sheet.largestUndimmedDetentIdentifier = .medium
//        }
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
        results.forEach { result in
            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] item, error in
                if let error = error {
                    debugPrint(error.localizedDescription)
                } else if let image = item as? UIImage {
                    DispatchQueue.main.async {
                        self?.imageView.image = image
                    }
                }
            }
        }
    }
}
