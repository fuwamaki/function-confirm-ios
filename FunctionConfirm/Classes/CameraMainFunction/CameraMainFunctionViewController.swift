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

    @IBAction private func clickImage1Button(_ sender: Any) {
    }

    @IBAction private func clickImage2Button(_ sender: Any) {
    }

    @IBAction private func clickImage3Button(_ sender: Any) {
    }

    @IBAction private func clickImage4Button(_ sender: Any) {
    }

    @IBAction private func clickTurnOverCamera(_ sender: Any) {
    }

    @IBAction private func clickChangeLightButton(_ sender: Any) {
    }

    @IBAction private func clickShutterButton(_ sender: Any) {
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

    // 背面カメラモード
//    private let videoDevice = AVCaptureDevice.default(for: .video)

    // ビデオデータ出力
//    private let metadataOutput = AVCaptureMetadataOutput()

    // プレビューレイヤー
    private var videoLayer: AVCaptureVideoPreviewLayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        #if targetEnvironment(simulator)
        debugPrint("simulatorでは起動不可")
        #else
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
