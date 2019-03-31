//
//  Barcode2ViewController.swift
//  FunctionConfirm
//
//  Created by Maki, Yusaku | Mackey | ECID on 2019/03/30.
//  Copyright © 2019年 牧宥作. All rights reserved.
//

import UIKit
import AVFoundation
import SafariServices

final class Barcode2ViewController: UIViewController {

    @IBOutlet private weak var detectionAreaStackView: UIStackView!
    @IBOutlet private weak var cameraPreviewView: UIView!
    @IBOutlet private weak var detectionAreaView: UIView!
    @IBOutlet private weak var resultTextLabel: UILabel!
    @IBOutlet private weak var resultUrlStackView: UIStackView!

    @IBAction private func clickWebPageButton(_ sender: Any) {
        if let url = webPageUrl {
            let safariViewController = SFSafariViewController(url: url)
            present(safariViewController, animated: true, completion: nil)
        }
    }

    // セッションのインスタンス
    private let captureSession = AVCaptureSession()

    // 背面カメラモード
    private let videoDevice = AVCaptureDevice.default(for: .video)

    // ビデオデータ出力
    private let metadataOutput = AVCaptureMetadataOutput()

    // webPageURL
    var webPageUrl: URL?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupBarcodeCapture()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        detectionAreaView.layer.borderColor = UIColor.green.cgColor
        detectionAreaView.layer.borderWidth = 3
    }

    private func setupViews() {
        resultTextLabel.text = ""
        resultUrlStackView.isHidden = true
    }

    private func setupBarcodeCapture() {
        do {
            let videoInput = try AVCaptureDeviceInput.init(device: videoDevice!)
            captureSession.addInput(videoInput)
            setupMetadataOutput()
            setupRectOfInterest()
            setupPreviewLayer()
            startCaptureSession()
        } catch let error as NSError {
            print(error)
        }
    }

    // 出力データの設定
    private func setupMetadataOutput() {
        captureSession.addOutput(metadataOutput)
        // メタデータを検出した際のデリゲート設定
        metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        // EAN-13コードの認識を設定
        metadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.ean13, AVMetadataObject.ObjectType.ean8]
    }

    // 検出エリアの設定
    private func setupRectOfInterest() {
        // memo: 長さではダメだったので、小数値で設定
        let x = (detectionAreaStackView.frame.origin.x + detectionAreaView.frame.origin.x)/cameraPreviewView.bounds.width
        let y = (detectionAreaStackView.frame.origin.y + detectionAreaView.frame.origin.y)/cameraPreviewView.bounds.height
        let width = (detectionAreaView.bounds.width)/cameraPreviewView.bounds.width
        let height = (detectionAreaView.bounds.height)/cameraPreviewView.bounds.height
        metadataOutput.rectOfInterest = CGRect(x: y, y: 1-x-width, width: height, height: width)
    }

    // プレビューレイヤーの設定
    private func setupPreviewLayer() {
        let videoLayer = AVCaptureVideoPreviewLayer.init(session: captureSession)
        videoLayer.frame = cameraPreviewView.bounds
        videoLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        cameraPreviewView.layer.addSublayer(videoLayer)
    }

    // セッションの開始
    private func startCaptureSession() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.startRunning()
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
                    if resultTextLabel.text != metadata.stringValue! {
                        resultTextLabel.text = metadata.stringValue!
                        detectionAreaView.layer.borderColor = UIColor.white.cgColor
                        detectionAreaView.layer.borderWidth = 5
                    }
                }
            }
        }
    }
}
