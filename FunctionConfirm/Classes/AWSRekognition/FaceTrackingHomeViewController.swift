//
//  FaceTrackingHomeViewController.swift
//  FunctionConfirm
//
//  Created by Maki, Yusaku | Mackey | ECID on 2019/02/06.
//  Copyright © 2019年 牧宥作. All rights reserved.
//

import UIKit
import SafariServices
import AWSRekognition

final class FaceTrackingHomeViewController: UIViewController {

    @IBOutlet private weak var celebImageView: UIImageView!

    var infoLinksMap: [Int: String] = [1000: ""]

    var navigationItemTitle: String? {
        didSet {
            navigationItem.title = navigationItemTitle
        }
    }

    @IBAction func CameraOpen(_ sender: Any) {
        // SimlatorではCrashを防ぐためにカメラ起動しないように
        #if targetEnvironment(simulator)
        #else
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .camera
        pickerController.cameraCaptureMode = .photo
        present(pickerController, animated: true)
        #endif
    }

    @IBAction func PhotoLibraryOpen(_ sender: Any) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .savedPhotosAlbum
        present(pickerController, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItemTitle = "AWS 顔認識"
    }

    private func sendImageToRekognition(celebImageData: Data) {
        //Delete older labels or buttons
        DispatchQueue.main.async { [weak self] in
            guard let subViews = self?.celebImageView.subviews else {
                return
            }
            for subView in subViews {
                subView.removeFromSuperview()
            }
        }

        let rekognitionObject = AWSRekognition.default()
        let celebImageAWS = AWSRekognitionImage()
        celebImageAWS?.bytes = celebImageData
        guard let celebRequest = AWSRekognitionRecognizeCelebritiesRequest() else {
            return
        }
        celebRequest.image = celebImageAWS

        rekognitionObject.recognizeCelebrities(celebRequest) { result, error in
            guard error == nil else {
                print(error!)
                return
            }

            guard let celebrityFaces = result?.celebrityFaces else {
                return
            }

            if celebrityFaces.count > 0 { // もし有名人なら
                for (index, celebFace) in celebrityFaces.enumerated() { // 識別した有名人の数だけ繰り返す
                    guard let value = celebFace.matchConfidence?.intValue, value > 50 else { // 有名人の信頼値が50以上か確認
                        return
                    }
                    DispatchQueue.main.async { [weak self] in
                        self?.displayCelebrityImage(index: index, celebFace: celebFace)
                    }
                }
            } else if let count = result?.unrecognizedFaces?.count, count > 0 {
                // 画像は存在している。画像内でそれをポインティングする（演習用）
            } else {
                print("No faces in this pic")
            }
        }
    }

    private func displayCelebrityImage(index: Int, celebFace: AWSRekognitionCelebrity) {
        let celebrityInImage = Celebrity()
        celebrityInImage.celebrityImageView = celebImageView
        // 認識した顔の座標を取得
        celebrityInImage.boundingBox = CGRect(x: celebFace.face?.boundingBox?.left?.doubleValue ?? 0.0,
                                              y: celebFace.face?.boundingBox?.top?.doubleValue ?? 0.0,
                                              width: celebFace.face?.boundingBox?.width?.doubleValue ?? 0.0,
                                              height: celebFace.face?.boundingBox?.height?.doubleValue ?? 0.0)
        celebrityInImage.name = celebFace.name ?? "no name"
        if let count = celebFace.urls?.count, count > 0 {
            celebrityInImage.infoLink = celebFace.urls![0]
        } else {
            celebrityInImage.infoLink = "https://www.imdb.com/search/name-text?bio=" + celebrityInImage.name
        }
        infoLinksMap[index] = "https://" + celebFace.urls![0]
        let infoButton: UIButton = celebrityInImage.infoButton
        infoButton.tag = index
        infoButton.addTarget(self, action: #selector(handleTap), for: UIControl.Event.touchUpInside)
        celebImageView.addSubview(infoButton)
    }
}

// MARK: UIImagePickerControllerDelegate
extension FaceTrackingHomeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        dismiss(animated: true)

        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            fatalError("couldn't load image from Photos")
        }
        celebImageView.image = image

        guard let celebImage: Data = image.jpegData(compressionQuality: 0.2) else {
            fatalError("optional convert error")
        }

        sendImageToRekognition(celebImageData: celebImage)
    }
}

extension FaceTrackingHomeViewController: SFSafariViewControllerDelegate {
    @objc func handleTap(sender: UIButton) {
        print("tap recognized")
        let celebURL = URL(string: infoLinksMap[sender.tag]!)!
        let safariController = SFSafariViewController(url: celebURL)
        safariController.delegate = self
        self.present(safariController, animated: true)
    }
}
