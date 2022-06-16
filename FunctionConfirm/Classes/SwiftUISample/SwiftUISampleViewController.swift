//
//  SwiftUISampleViewController.swift
//  FunctionConfirm
//
//  Created by fuwamaki on 2022/06/16.
//  Copyright © 2022 fuwamaki. All rights reserved.
//

import UIKit
import SwiftUI

final class SwiftUISampleViewController: UIViewController {

    @IBAction private func clickButton(_ sender: UIButton) {
        let sampleView = SwiftUISampleView()
        let hostingController = UIHostingController(rootView: sampleView)
        self.present(hostingController, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
