//
//  BarcodeViewController.swift
//  FunctionConfirm
//
//  Created by Maki, Yusaku | Mackey | ECID on 2019/03/29.
//  Copyright © 2019年 牧宥作. All rights reserved.
//

import UIKit
import AVFoundation

// not working
final class BarcodeViewController: UIViewController {

    @IBOutlet weak var captureView: UIView!
    @IBOutlet weak var resultTextLabel: UILabel!

    private lazy var captureSession: AVCaptureSession = AVCaptureSession()
    private lazy var capturePreviewLayer: AVCaptureVideoPreviewLayer = {
        let layer = AVCaptureVideoPreviewLayer(session: self.captureSession)
        return layer
    }()

    private var captureInput: AVCaptureInput?
    private lazy var captureOutput: AVCaptureMetadataOutput = {
        let output = AVCaptureMetadataOutput()
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        return output
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupBarcodeCapture()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let bounds = captureView?.bounds {
            capturePreviewLayer.frame = bounds
        }
    }

    // MARK: - private
    private func setupBarcodeCapture() {
        do {
            let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
            captureInput = try AVCaptureDeviceInput(device: captureDevice!)
            guard let captureInput = captureInput else {
                return
            }
            captureSession.addInput(captureInput)
            captureOutput.metadataObjectTypes = captureOutput.availableMetadataObjectTypes
            captureSession.addOutput(captureOutput)
            if let bounds = self.captureView?.bounds {
                capturePreviewLayer.frame = bounds
            }
            capturePreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            captureView?.layer.addSublayer(capturePreviewLayer)
            captureSession.startRunning()
        } catch let error as NSError {
            print(error)
        }
    }

    private func convartISBN(value: String) -> String? {
        let v = NSString(string: value).longLongValue
        let prefix: Int64 = Int64(v / 10000000000)
        guard prefix == 978 || prefix == 979 else { return nil }
        let isbn9: Int64 = (v % 10000000000) / 10
        var sum: Int64 = 0
        var tmpISBN = isbn9
        /*
         for var i = 10; i > 0 && tmpISBN > 0; i -= 1 {
         let divisor: Int64 = Int64(pow(10, Double(i - 2)))
         sum += (tmpISBN / divisor) * Int64(i)
         tmpISBN %= divisor
         }
         */

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

extension BarcodeViewController: AVCaptureMetadataOutputObjectsDelegate {

    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        self.captureSession.stopRunning()
        guard let objects = metadataObjects as? [AVMetadataObject] else { return }
        var detectionString: String?
        let barcodeTypes = [AVMetadataObject.ObjectType.ean8, AVMetadataObject.ObjectType.ean13]
        for metadataObject in objects {
            loop: for type in barcodeTypes {
                guard metadataObject.type == type else { continue }
                guard self.capturePreviewLayer.transformedMetadataObject(for: metadataObject) is AVMetadataMachineReadableCodeObject else { continue }
                if let object = metadataObject as? AVMetadataMachineReadableCodeObject {
                    detectionString = object.stringValue
                    break loop
                }
            }
            var text = ""
            guard let value = detectionString else { continue }
            text += "読み込んだ値:\t\(value)"
            text += "\n"
            guard let isbn = convartISBN(value: value) else { continue }
            text += "ISBN:\t\(isbn)"
            resultTextLabel?.text = text
            let URLString = String(format: "http://amazon.co.jp/dp/%@", isbn)
            guard let URL = NSURL(string: URLString) else { continue }
            UIApplication.shared.open(URL as URL)
        }
        self.captureSession.startRunning()
    }
}
