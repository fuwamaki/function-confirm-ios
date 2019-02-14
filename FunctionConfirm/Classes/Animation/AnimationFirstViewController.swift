//
//  AnimationFirstViewController.swift
//  FunctionConfirm
//
//  Created by Maki, Yusaku | Mackey | ECID on 2019/02/14.
//  Copyright © 2019年 牧宥作. All rights reserved.
//

import UIKit

final class AnimationFirstViewController: UIViewController {

    @IBOutlet private weak var block1Label: UILabel!
    @IBOutlet private weak var block2Label: UILabel!
    @IBOutlet private weak var block3Label: UILabel!
    @IBOutlet private weak var block4Label: UILabel!
    @IBOutlet private weak var block5Label: UILabel!
    @IBOutlet private weak var block6Label: UILabel!
    @IBOutlet private weak var block7Label: UILabel!
    @IBOutlet private weak var block8Label: UILabel!
    @IBOutlet private weak var block9Label: UILabel!
    @IBOutlet private weak var block10Label: UILabel!
    @IBOutlet private weak var block11Label: UILabel!
    @IBOutlet private weak var block12Label: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // y軸に40下がった状態から、元の高さに上がって、また40下がる
        UIView.animate(withDuration: 1.0, delay: 0.0, options: .autoreverse, animations: {
            self.block1Label.center.y -= 40.0
        }, completion: nil)
    }
}
