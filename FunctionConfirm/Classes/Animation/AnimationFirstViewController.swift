//
//  AnimationFirstViewController.swift
//  FunctionConfirm
//
//  Created by Maki, Yusaku | Mackey | ECID on 2019/02/14.
//  Copyright © 2019年 牧宥作. All rights reserved.
//

import UIKit

// UIView.animateを試す用のクラス
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
        // viewDidLoadではanimation処理を置いてはいけない
        // なぜならば、viewDidLoadはViewの生成をする箇所であり、Viewの生成と同時にアニメーションをしてはいけないから。
        // 実際にAnimationによってはviewDidLoadで動作しないケースが存在する。
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startAnimating()
    }

    private func startAnimating() {
        // memo - animateの引数について補足
        // withDuration: 実行時間
        // delay: 実行までの遅延

        // memo - オプションの種類について
        // .autoreverse: アニメーション逆再生

        // y軸に40下がった状態から、元の高さに上がって、また40下がる
        UIView.animate(withDuration: 1.0, delay: 0.0, options: .autoreverse, animations: {
            self.block1Label.center.y -= 40.0
        }, completion: nil)

        UIView.animate(withDuration: 1.0, delay: 0.0, options: [.curveEaseIn, .autoreverse], animations: {
            self.block2Label.center.y -= 40.0
        }, completion: nil)

        UIView.animate(withDuration: 1.0, delay: 0.0, options: [.curveEaseIn, .autoreverse], animations: {
            self.block3Label.center.y -= 40.0
        }, completion: { _ in
            self.block3Label.center.y += 40.0
        })

        block4Label.alpha = 0.0
        UIView.animate(withDuration: 1.0, delay: 0.0, options: [.curveEaseIn], animations: {
            self.block4Label.alpha = 1.0
        }, completion: nil)

        UIView.animate(withDuration: 2.0, delay: 0.0, options: [.repeat], animations: {
            self.block5Label.center.y -= 40.0
        }, completion: nil)

        UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.1, initialSpringVelocity: 0.0, options: .autoreverse, animations: {
            self.block6Label.center.y -= 40.0
            self.block6Label.bounds = CGRect(x: self.block6Label.center.x, y: self.block6Label.center.y, width: self.block6Label.bounds.width - 20, height: self.block6Label.bounds.height - 20)
        }, completion: { _ in
            self.block6Label.center.y += 40.0
            self.block6Label.bounds = CGRect(x: self.block6Label.center.x, y: self.block6Label.center.y, width: self.block6Label.bounds.width + 20, height: self.block6Label.bounds.height + 20)
        })
    }
}
