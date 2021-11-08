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

    override func viewDidLoad() {
        super.viewDidLoad()
        let label: MTMathUILabel = MTMathUILabel(
            frame: CGRect(x: 10, y: 280, width: 330, height: 80))
        label.fontSize = 18
//        label.latex = "x = \\frac{-b \\pm \\sqrt{b^2-4ac}}{2a}"
        label.latex = "\\cos(\\theta + \\varphi) = \\cos(\\theta)\\cos(\\varphi) - \\sin^2(\\theta)\\sin(\\varphi)"
        view.addSubview(label)
    }
}
