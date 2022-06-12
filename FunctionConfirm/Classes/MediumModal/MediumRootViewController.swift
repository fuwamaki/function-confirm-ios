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
//            sheet.detents = [.large(), .custom { _ in 200.0 }]
//            sheet.detents = [.large(), .custom { context in 0.3*context.maximumDetentValue }]
//            sheet.prefersGrabberVisible = true
//            sheet.largestUndimmedDetentIdentifier = .medium
//        }
        let viewController = TestChildViewController.make(text: "test")
        if let sheet = viewController.sheetPresentationController {
            sheet.detents = [
                .custom { context in 0.7*context.maximumDetentValue },
                .custom { context in 0.4*context.maximumDetentValue },
                .custom { context in 0.1*context.maximumDetentValue }
            ]
        }
        present(viewController, animated: true)
    }

    private lazy var phpickerViewController: PHPickerViewController = {
        var configuration = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
        configuration.filter = .images
        configuration.selectionLimit = 1
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
    func picker(
        _ picker: PHPickerViewController,
        didFinishPicking results: [PHPickerResult]
    ) {
        picker.dismiss(animated: true, completion: nil)
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
