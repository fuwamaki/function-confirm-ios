//
//  SpeechViewController.swift
//  FunctionConfirm
//
//  Created by yusaku maki on 2020/09/17.
//  Copyright © 2020 牧宥作. All rights reserved.
//

import UIKit
import Speech

final class SpeechViewController: UIViewController {

    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "ja-JP"))!
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()

    override func viewDidLoad() {
        super.viewDidLoad()
        requestRecognizerAuthorization()
        try? start()
    }

    private func requestRecognizerAuthorization() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            print(authStatus)
        }
    }

    private func start() throws {
        if let recognitionTask = recognitionTask {
            recognitionTask.cancel()
            self.recognitionTask = nil
        }

        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.record, mode: .measurement, options: [])
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)

        let recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        self.recognitionRequest = recognitionRequest
        recognitionRequest.shouldReportPartialResults = true
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { [weak self] (result, error) in
            guard let `self` = self else { return }

            var isFinal = false

            if let result = result {
                // 音声文字列
                print(result.bestTranscription.formattedString)
                isFinal = result.isFinal
            }

            if error != nil || isFinal {
                self.audioEngine.stop()
                self.audioEngine.inputNode.removeTap(onBus: 0)
                self.recognitionRequest = nil
                self.recognitionTask = nil
            }
        }

        let recordingFormat = audioEngine.inputNode.outputFormat(forBus: 0)
        audioEngine.inputNode.installTap(
            onBus: 0,
            bufferSize: 1024,
            format: recordingFormat) { buffer, _ in
                self.recognitionRequest?.append(buffer)
        }

        audioEngine.prepare()
        try? audioEngine.start()
    }

    private func stop() {
        audioEngine.stop()
        recognitionRequest?.endAudio()
    }
}
