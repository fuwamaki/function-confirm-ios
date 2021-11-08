//
//  MathViewController.swift
//  FunctionConfirm
//
//  Created by yusaku maki on 2021/11/08.
//  Copyright © 2021 fuwamaki. All rights reserved.
//

import UIKit
import iosMath
import WebKit

final class MathViewController: UIViewController {

    @IBOutlet private weak var mathView: MTMathUILabel!
    @IBOutlet private weak var mathWKView: KatexMathView!

    override func viewDidLoad() {
        super.viewDidLoad()
        mathView.fontSize = 18
        mathView.latex = "x = \\frac{-b \\pm \\sqrt{b^2-4ac}}{2a}"

        let latex: String = "Find the value of $k$, if $x + 6$ is a factor of $- k + x^{3} + 16 x^{2} + 76 x$"
        mathWKView.loadLatex(latex)
    }
}
