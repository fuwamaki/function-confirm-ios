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
    @IBOutlet private weak var resultUrlButton: UIButton!

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

    // プレビューレイヤー
    private var videoLayer: AVCaptureVideoPreviewLayer?

    // webPageURL
    private var webPageUrl: URL? {
        didSet {
            guard let url = webPageUrl else { return }
            // memo: button.textLabel.titleでは横幅が可変にならない
            resultUrlButton.setTitle(String(describing: url), for: .normal)
            resultUrlButton.sizeToFit()
            if resultUrlButton.isHidden { resultUrlButton.isHidden = false }
        }
    }

    // 検出エリアの枠線更新用タイマー&カウント
    private var timer: Timer?
    private var counter: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        #if targetEnvironment(simulator)
        resultTextLabel.text = "Simulatorではカメラ起動不可"
        #else
        setupBarcodeCapture()
        #endif
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    private func setupViews() {
        resultTextLabel.text = ""
        resultUrlButton.titleLabel?.text = ""
        resultUrlButton.isHidden = true
        detectionAreaView.layer.borderColor = UIColor.green.cgColor
        detectionAreaView.layer.borderWidth = 3
    }

    private func setupBarcodeCapture() {
        do {
            let videoInput = try AVCaptureDeviceInput.init(device: videoDevice!)
            captureSession.addInput(videoInput)
            setupMetadataOutput()
            setupRectOfInterest()
            setupPreviewLayer()
            startCaptureSession()
            setupTimer()
        } catch let error as NSError {
            print(error)
        }
    }

    // 出力データの設定
    private func setupMetadataOutput() {
        captureSession.addOutput(metadataOutput)
        // メタデータを検出した際のデリゲート設定
        metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        // janコード(ean13)とqrコード(qr)認識を設定
        metadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.ean13, AVMetadataObject.ObjectType.ean8, AVMetadataObject.ObjectType.qr]
    }

    // 検出エリアの設定
    private func setupRectOfInterest() {
        // memo: 長さではダメだったので、小数値で設定
        let x = (detectionAreaStackView.frame.origin.x + detectionAreaView.frame.origin.x)/cameraPreviewView.bounds.width
        let y = (detectionAreaStackView.frame.origin.y + detectionAreaView.frame.origin.y)/cameraPreviewView.bounds.height
        let width = (detectionAreaView.bounds.width)/cameraPreviewView.bounds.width
        let height = (detectionAreaView.bounds.height)/cameraPreviewView.bounds.height
        metadataOutput.rectOfInterest = CGRect(x: y, y: 1 - x - width, width: height, height: width)
    }

    // プレビューレイヤーの設定
    private func setupPreviewLayer() {
        videoLayer = AVCaptureVideoPreviewLayer.init(session: captureSession)
        videoLayer?.frame = cameraPreviewView.bounds
        videoLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        if let videoLayer = videoLayer {
            cameraPreviewView.layer.addSublayer(videoLayer)
        }
    }

    // セッションの開始
    private func startCaptureSession() {
        //ユーザアクションに起因する非同期タスクとして実行（優先度high設定）
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.startRunning()
        }
    }

    // タイマーの設定
    private func setupTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(updateResultOfDetection), userInfo: nil, repeats: true)
        timer?.fire()
    }

    // 検出結果の更新
    @objc private func updateResultOfDetection() {
        counter += 1
        if counter > 2 {
            detectionAreaView.layer.borderColor = UIColor.green.cgColor
            detectionAreaView.layer.borderWidth = 4
            resultTextLabel.text = ""
        }
    }

    private func convertISBN(value: String) -> String? {
        let int64Value = NSString(string: value).longLongValue
        let prefix: Int64 = Int64(int64Value / 10000000000)
        guard prefix == 978 || prefix == 979 else { return nil }
        let isbn9: Int64 = (int64Value % 10000000000) / 10
        var sum: Int64 = 0
        var tmpISBN = isbn9
        var i = 10
        while i > 0 && tmpISBN > 0 {
            let divisor: Int64 = Int64(pow(10, Double(i - 2)))
            sum += (tmpISBN / divisor) * Int64(i)
            tmpISBN %= divisor
            i -= 1
        }
        let checkdigit = 11 - (sum % 11)
        return String(format: "%lld%@", isbn9, (checkdigit == 10) ? "X" : String(format: "%lld", checkdigit % 11))
    }
}

extension Barcode2ViewController: AVCaptureMetadataOutputObjectsDelegate {
    // バーコードを検出すると呼び出されるメソッド
    // memo: captureOutputではないので注意
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard let metadataObjects = metadataObjects as? [AVMetadataMachineReadableCodeObject] else { return }
        // 複数のメタデータ検出
        loop: for metadata in metadataObjects {
            switch metadata.type {
            // janコードを検出した場合
            case AVMetadataObject.ObjectType.ean8, AVMetadataObject.ObjectType.ean13:
                guard let metadataValue = metadata.stringValue, resultTextLabel.text != metadataValue else { return }
                resultTextLabel.text = metadataValue
                detectionAreaView.layer.borderColor = UIColor.white.cgColor
                detectionAreaView.layer.borderWidth = 6
                counter = 0
                if let isbn = convertISBN(value: metadataValue), let url = URL(string: "http://amazon.co.jp/dp/\(isbn)") {
                    webPageUrl = url
                }
                break loop
            // qrコードを検出した場合
            case AVMetadataObject.ObjectType.qr where counter > 1:
                guard let metadataValue = metadata.stringValue, resultTextLabel.text != metadataValue else { return }
                resultTextLabel.text = metadataValue
                detectionAreaView.layer.borderColor = UIColor.white.cgColor
                detectionAreaView.layer.borderWidth = 6
                counter = 0
                // URL文字列か識別。（ちょっと雑）
                if metadataValue.contains("http"), let url = URL(string: metadataValue) {
                    webPageUrl = url
                }
                break loop
            default:
                break
            }
        }
    }
}

// 横向きに対応する方法
// https://teratail.com/questions/131390
