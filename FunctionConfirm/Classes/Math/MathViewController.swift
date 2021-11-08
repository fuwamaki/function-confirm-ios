//
//  MathViewController.swift
//  FunctionConfirm
//
//  Created by yusaku maki on 2021/11/08.
//  Copyright © 2021 fuwamaki. All rights reserved.
//

import UIKit
import iosMath

final class MathViewController: UIViewController {

    @IBOutlet weak var mathView: MTMathUILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        mathView.fontSize = 18
        mathView.latex = "x = \\frac{-b \\pm \\sqrt{b^2-4ac}}{2a}"
    }
}
