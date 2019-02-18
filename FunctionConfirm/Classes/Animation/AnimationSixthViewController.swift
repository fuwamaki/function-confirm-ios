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
        // view1と同じ処理がCore AnimationのCABasicAnimationを使って実現
        let animation = CABasicAnimation(keyPath: "cornerRadius")
        animation.duration = 2.0 // Animation時間
        animation.fromValue = 0.0 // アニメーション前の値をセット（指定しない場合は現状の値）
        animation.toValue = 20.0 // アニメーション後の値をセット
        animation.autoreverses = false // 逆再生の可否
        animation.isRemovedOnCompletion = false // アニメーション後の値をそのまま保持したい場合はfalse
        animation.fillMode = .forwards // アニメーション後の値をそのまま保持したい場合は.forwards
        view2.layer.add(animation, forKey: nil)
        // memo: CoreAnimation 中級編
        // https://qiita.com/inamiy/items/bdc0eb403852178c4ea7#fillmode%E3%81%AB%E3%81%A4%E3%81%84%E3%81%A6
    }

    @IBAction func clickButton3(_ sender: Any) {
        let animationGroup = CAAnimationGroup()
        animationGroup.duration = 1.0
        animationGroup.fillMode = .forwards
        animationGroup.isRemovedOnCompletion = false

        let animation1 = CABasicAnimation(keyPath: "transform.scale")
        animation1.fromValue = 2.0
        animation1.toValue = 1.0

        let animation2 = CABasicAnimation(keyPath: "cornerRadius")
        animation2.fromValue = 0.0
        animation2.toValue = 20.0

        let animation3 = CABasicAnimation(keyPath: "transform.rotation")
        animation3.fromValue = 0.0
        animation3.toValue = Double.pi * 2.0
        animation3.speed = 2.0

        animationGroup.animations = [animation1, animation2, animation3]
        view3.layer.add(animationGroup, forKey: nil)
    }

    @IBAction func clickButton4(_ sender: Any) {
        let animation = CASpringAnimation(keyPath: "transform.scale")
        animation.duration = 2.0
        animation.fromValue = 1.25
        animation.toValue = 1.0
        animation.mass = 1.0 // 質量
        animation.initialVelocity = 30.0
        animation.damping = 3.0 // 硬さ
        animation.stiffness = 120.0
        view4.layer.add(animation, forKey: nil)
    }

    @IBAction func clickButton5(_ sender: Any) {
        let animation = CAKeyframeAnimation(keyPath: "cornerRadius")
        animation.duration = 2.0
        animation.keyTimes = [0.0, 0.25, 0.5, 0.75]
        animation.values = [20.0, 3.0, 20.0, 10.0]
        view5.layer.add(animation, forKey: nil)
    }

    @IBAction func clickButton6(_ sender: Any) {
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            self.view6.backgroundColor = UIColor.red
        }
        let animation = CABasicAnimation(keyPath: "cornerRadius")
        animation.duration = 1.0
        animation.fromValue = 0.0
        animation.toValue = 20.0
        view6.layer.add(animation, forKey: nil)
        CATransaction.commit()
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
