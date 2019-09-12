//
//  TimerViewController.swift
//  FunctionConfirm
//
//  Created by yusaku maki on 2019/09/12.
//  Copyright © 2019 牧宥作. All rights reserved.
//

import UIKit

final class TimerViewController: UIViewController {

    @IBOutlet private weak var timerLabel: UILabel!

    private var time: Double = 10800
    private lazy var dateFormatter: DateComponentsFormatter = {
        let dateFormatter = DateComponentsFormatter()
        dateFormatter.unitsStyle = .positional
        dateFormatter.allowedUnits = [.hour, .minute, .second]
        return dateFormatter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        timerLabel.text = dateFormatter.string(from: time)
        Timer.scheduledTimer(timeInterval: 1,
                             target: self,
                             selector: #selector(updateTimer),
                             userInfo: nil,
                             repeats: true)
    }

    @objc func updateTimer() {
        time -= 1
        timerLabel.text = dateFormatter.string(from: time)
    }
}
