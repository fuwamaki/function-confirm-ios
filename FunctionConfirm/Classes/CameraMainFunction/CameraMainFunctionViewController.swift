//
//  CameraMainFunctionViewController.swift
//  FunctionConfirm
//
//  Created by Maki, Yusaku | Mackey | ECID on 2019/04/24.
//  Copyright © 2019年 牧宥作. All rights reserved.
//

import UIKit
import AVFoundation

final class CameraMainFunctionViewController: UIViewController {

    @IBOutlet private weak var cameraPreviewView: UIView!

    @IBOutlet weak var firstImageView: UIImageView! {
        didSet {
            firstImageView.isUserInteractionEnabled = true
            firstImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickFirstImageView)))
        }
    }

    @IBOutlet weak var secondImageView: UIImageView! {
        didSet {
            secondImageView.isUserInteractionEnabled = true
            secondImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickSecondImageView)))
        }
    }

    @IBOutlet weak var thirdImageView: UIImageView! {
        didSet {
            thirdImageView.isUserInteractionEnabled = true
            thirdImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickThirdImageView)))
        }
    }

    @IBOutlet weak var fourthImageView: UIImageView! {
        didSet {
            fourthImageView.isUserInteractionEnabled = true
            fourthImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickFourthImageView)))
        }
    }

    @IBAction private func clickTurnOverCamera(_ sender: Any) {
    }

    @IBAction private func clickChangeLightButton(_ sender: Any) {
    }

    @IBAction private func clickShutterButton(_ sender: Any) {
        let settings = AVCapturePhotoSettings()
        settings.flashMode = .auto
        settings.isAutoStillImageStabilizationEnabled = true
        settings.isHighResolutionPhotoEnabled = false
        photoOutput?.capturePhoto(with: settings, delegate: self)
    }

    // セッションのインスタンス
    private var captureSession: AVCaptureSession = {
        var session = AVCaptureSession()
        session.sessionPreset = .photo
        return session
    }()

    // 現在のカメラデバイス
    private var currentDevice: AVCaptureDevice?

    // メインカメラの管理オブジェクトの作成
    var mainCamera: AVCaptureDevice?

    // インカメの管理オブジェクトの作成
    var innerCamera: AVCaptureDevice?

    // キャプチャーの出力データを受け付けるオブジェクト
    var photoOutput: AVCapturePhotoOutput?

    // プレビューレイヤー
    private var videoLayer: AVCaptureVideoPreviewLayer?

    // imageViewの配列
    private var imageViews: [UIImageView] = []
    private var imageData: [Data] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        #if targetEnvironment(simulator)
        debugPrint("simulatorでは起動不可")
        #else
        setupImageViews()
        setupDevice()
        setupInputOutput()
        setupPreviewLayer()
        startCaptureSession()
        #endif
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        videoLayer?.frame = cameraPreviewView.bounds
        videoLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        if let videoLayer = videoLayer {
            cameraPreviewView.layer.addSublayer(videoLayer)
        }
    }

    private func displayActionSheet(imageIndex: Int) {
        let alert = UIAlertController(title: "アクション", message: nil, preferredStyle: .actionSheet)
        let manufacturingAction = UIAlertAction(title: "加工", style: .default, handler: nil)
        let deleteAction = UIAlertAction(title: "削除", style: .destructive) { [weak self] _ in
            self?.imageData.remove(at: imageIndex)
            self?.reloadImageViews()
        }
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        alert.addAction(manufacturingAction)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }

    private func reloadImageViews() {
        imageViews.forEach { imageView in
            imageView.image = nil
            imageView.isUserInteractionEnabled = false
        }
        imageData.enumerated().forEach { index, data in
            let image = UIImage(data: data)
            imageViews[index].image = image
            imageViews[index].isUserInteractionEnabled = true
        }
    }
}

// MARK: setup
extension CameraMainFunctionViewController {
    private func setupImageViews() {
        imageViews = [firstImageView, secondImageView, thirdImageView, fourthImageView]
        imageViews.forEach { imageView in
            imageView.image = nil
        }
        // memo: ImageViewにタップできるようButtonで生成してみたら、setImageができなかった。
    }

    // デバイスの設定
    private func setupDevice() {
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .unspecified)
        let devices = deviceDiscoverySession.devices
        for device in devices {
            if device.position == .back {
                mainCamera = device
            } else if device.position == .front {
                innerCamera = device
            }
        }
        // 起動時のカメラを設定
        currentDevice = mainCamera
    }

    // 入出力データの設定
    private func setupInputOutput() {
        do {
            let captureDeviceInput = try AVCaptureDeviceInput(device: currentDevice!)
            captureSession.addInput(captureDeviceInput)
            photoOutput = AVCapturePhotoOutput()
            photoOutput?.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])], completionHandler: nil)
            captureSession.addOutput(photoOutput!)
        } catch {
            print(error)
        }
    }

    // プレビューレイヤーの設定
    private func setupPreviewLayer() {
        videoLayer = AVCaptureVideoPreviewLayer(session: captureSession)
    }

    // セッションの開始
    private func startCaptureSession() {
        //ユーザアクションに起因する非同期タスクとして実行（優先度high設定）
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.startRunning()
        }
    }
}

// selector
extension CameraMainFunctionViewController {
    @objc func clickFirstImageView() {
        displayActionSheet(imageIndex: 0)
    }

    @objc func clickSecondImageView() {
        displayActionSheet(imageIndex: 1)
    }

    @objc func clickThirdImageView() {
        displayActionSheet(imageIndex: 2)
    }

    @objc func clickFourthImageView() {
        displayActionSheet(imageIndex: 3)
    }
}

extension CameraMainFunctionViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard error == nil else {
            print("撮影失敗")
            return
        }
        if let photoData = photo.fileDataRepresentation() {
            imageData.append(photoData)
            reloadImageViews()
        }
    }
}
