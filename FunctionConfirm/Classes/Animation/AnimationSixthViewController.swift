//
//  AnimationSixthViewController.swift
//  FunctionConfirm
//
//  Created by Maki, Yusaku | Mackey | ECID on 2019/02/17.
//  Copyright © 2019年 牧宥作. All rights reserved.
//

import UIKit

final class AnimationSixthViewController: UIViewController {

    @IBOutlet private weak var view1: UIView!
    @IBOutlet private weak var view2: UIView!
    @IBOutlet private weak var view3: UIView!
    @IBOutlet private weak var view4: UIView!
    @IBOutlet private weak var view5: UIView!
    @IBOutlet private weak var view6: UIView!
    @IBOutlet private weak var view7: UIView!
    @IBOutlet private weak var view8: UIView!

    @IBAction func clickButton1(_ sender: Any) {
        // cornerradiusはUIKitのアニメーション非対応
        // 2秒でcornerRadiusが20になるようにアニメーションしたいけどパッと切り替わったようになってしまう
        // 昔はそうだったみたいだけど、今は正常っぽい
        UIView.animate(withDuration: 2.0, animations: {
            self.view1.layer.cornerRadius = 20.0
        }, completion: nil)
    }

    @IBAction func clickButton2(_ sender: Any) {
        let animation = CABasicAnimation(keyPath: "cornerRadius")
        animation.duration = 2.0
        animation.fromValue = 0.0
        animation.toValue = 20.0
        animation.autoreverses = false
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.forwards
        view2.layer.add(animation, forKey: nil)
    }

    @IBAction func clickButton3(_ sender: Any) {
    }

    @IBAction func clickButton4(_ sender: Any) {
    }

    @IBAction func clickButton5(_ sender: Any) {
    }

    @IBAction func clickButton6(_ sender: Any) {
    }

    @IBAction func clickButton7(_ sender: Any) {
    }

    @IBAction func clickButton8(_ sender: Any) {
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}
