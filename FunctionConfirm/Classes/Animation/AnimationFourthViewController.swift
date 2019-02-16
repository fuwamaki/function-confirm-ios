//
//  AnimationFourthViewController.swift
//  FunctionConfirm
//
//  Created by Maki, Yusaku | Mackey | ECID on 2019/02/14.
//  Copyright © 2019年 牧宥作. All rights reserved.
//

import UIKit

// StackViewのAnimationを試す用のクラス
final class AnimationFourthViewController: UIViewController {

    @IBOutlet private weak var view1: UIView!
    @IBOutlet private weak var view2: UIView!
    @IBOutlet private weak var view3: UIView!
    @IBOutlet private weak var view4: UIView!
    @IBOutlet private weak var view5: UIView!

    @IBAction func clickButton1(_ sender: Any) {
        switch view1.isHidden {
        case true:
            UIView.animate(withDuration: 0.3) {
                self.view1.isHidden = false
            }
        case false:
            UIView.animate(withDuration: 0.3) {
                self.view1.isHidden = true
            }
        }
    }

    @IBAction func clickButton2(_ sender: Any) {
        switch view2.isHidden {
        case true:
            UIView.animate(withDuration: 0.5, animations: {
                self.view2.isHidden = false
                self.view2.alpha = 1.0
            })
        case false:
            UIView.animate(withDuration: 0.5, animations: {
                self.view2.alpha = 0.0
            }, completion: { _ in
                UIView.animate(withDuration: 0.5, animations: {
                    self.view2.isHidden = true
                })
            })
        }
    }

    @IBAction func clickButton3(_ sender: Any) {
    }

    @IBAction func clickButton4(_ sender: Any) {
    }

    @IBAction func clickButton5(_ sender: Any) {
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
