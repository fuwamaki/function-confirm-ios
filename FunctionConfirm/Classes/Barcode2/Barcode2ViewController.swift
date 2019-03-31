//
//  Barcode2ViewController.swift
//  FunctionConfirm
//
//  Created by Maki, Yusaku | Mackey | ECID on 2019/03/30.
//  Copyright © 2019年 牧宥作. All rights reserved.
//

import UIKit
import AVFoundation

class Barcode2ViewController: UIViewController {

    @IBOutlet private weak var previewView: UIView!
    @IBOutlet private weak var label: UILabel!

    let detectionArea = UIView()
    var isDetected = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBarcodeCapture()
    }

    private func setupBarcodeCapture() {
        // セッションのインスタンス生成
        let captureSession = AVCaptureSession()

        // 入力（背面カメラ）
        let videoDevice = AVCaptureDevice.default(for: .video)
        let videoInput = try! AVCaptureDeviceInput.init(device: videoDevice!)
        captureSession.addInput(videoInput)

        // 出力（ビデオデータ）
        let metadataOutput = AVCaptureMetadataOutput()
        captureSession.addOutput(metadataOutput)

        // メタデータを検出した際のデリゲート設定
        metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        // EAN-13コードの認識を設定
        metadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.ean13, AVMetadataObject.ObjectType.ean8]

        // 検出エリアのビュー
        let x: CGFloat = 0.05
        let y: CGFloat = 0.3
        let width: CGFloat = 0.9
        let height: CGFloat = 0.2

        detectionArea.frame = CGRect(x: view.frame.size.width * x, y: view.frame.size.height * y, width: view.frame.size.width * width, height: view.frame.size.height * height)
        detectionArea.layer.borderColor = UIColor.red.cgColor
        detectionArea.layer.borderWidth = 3
        view.addSubview(detectionArea)

        // 検出エリアの設定
        metadataOutput.rectOfInterest = CGRect(x: y, y: 1-x-width, width: height, height: width)

        // プレビュー
        // if letとった。
        let videoLayer = AVCaptureVideoPreviewLayer.init(session: captureSession)
        videoLayer.frame = previewView.bounds
        videoLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        previewView.layer.addSublayer(videoLayer)

        // セッションの開始
        DispatchQueue.global(qos: .userInitiated).async {
            captureSession.startRunning()
        }
    }
}

extension Barcode2ViewController: AVCaptureMetadataOutputObjectsDelegate {
    // memo: captureOutputではない。
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // 複数のメタデータを検出できる
        for metadata in metadataObjects as! [AVMetadataMachineReadableCodeObject] {
            // EAN-13Qコードのデータかどうかの確認
            if metadata.type == AVMetadataObject.ObjectType.ean13 || metadata.type == AVMetadataObject.ObjectType.ean8 {
                if metadata.stringValue != nil {
                    // 検出データを取得
                    if !isDetected || label.text != metadata.stringValue! {
                        isDetected = true
                        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate) // バイブレーション
                        label.text = metadata.stringValue!
                        detectionArea.layer.borderColor = UIColor.white.cgColor
                        detectionArea.layer.borderWidth = 5
                    }
                }
            }
        }
    }
}
