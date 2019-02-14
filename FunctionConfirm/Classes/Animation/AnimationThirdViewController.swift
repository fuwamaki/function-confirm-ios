//
//  AnimationThirdViewController.swift
//  FunctionConfirm
//
//  Created by Maki, Yusaku | Mackey | ECID on 2019/02/14.
//  Copyright © 2019年 牧宥作. All rights reserved.
//

import UIKit

// StackViewのAnimationを試す用のクラス
final class AnimationThirdViewController: UIViewController {

    @IBOutlet private weak var purpleView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let purpleView = purpleView else {
            return
        }
        let redView = UIView(frame: purpleView.frame)
        redView.backgroundColor = .red
        UIView.transition(from: purpleView, to: redView, duration: 1.0, options: [.transitionCurlDown, .autoreverse], completion: { _ in
            redView.removeFromSuperview()
        })
    }
}
