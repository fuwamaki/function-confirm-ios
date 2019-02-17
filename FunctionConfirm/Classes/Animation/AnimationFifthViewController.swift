//
//  AnimationFifthViewController.swift
//  FunctionConfirm
//
//  Created by Maki, Yusaku | Mackey | ECID on 2019/02/17.
//  Copyright © 2019年 牧宥作. All rights reserved.
//

import UIKit

final class AnimationFifthViewController: UIViewController {

    @IBOutlet private weak var blockLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // animateKeyframesを使えば、複数のアニメーションをセットできる
        UIView.animateKeyframes(withDuration: 2.0, delay: 0.0, options: [.autoreverse], animations: {

            // 100下に移動
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.25, animations: {
                self.blockLabel.center.y += 100.0
            })

            // 90度回転
            // memo: Double.piは円周率
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.1, animations: {
                self.blockLabel.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 2))
            })

            // 100右に移動
            UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.25, animations: {
                self.blockLabel.center.x += 100.0
            })

            // 180度回転
            UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.1, animations: {
                self.blockLabel.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
            })

            // 100上に移動
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.25, animations: {
                self.blockLabel.center.y -= 100.0
            })

            // 270度回転
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.1, animations: {
                self.blockLabel.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi + Double.pi / 2))
            })

            // 100左に移動
            UIView.addKeyframe(withRelativeStartTime: 0.75, relativeDuration: 0.25, animations: {
                self.blockLabel.center.x -= 100.0
            })

            // 360度回転
            UIView.addKeyframe(withRelativeStartTime: 0.75, relativeDuration: 0.1, animations: {
                self.blockLabel.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi * 2.0))
            })

        }, completion: nil)
    }
}
