//
//  AnimationSecondViewController.swift
//  FunctionConfirm
//
//  Created by Maki, Yusaku | Mackey | ECID on 2019/02/14.
//  Copyright © 2019年 牧宥作. All rights reserved.
//

import UIKit

// UIView.transitionを試す用のクラス
final class AnimationSecondViewController: UIViewController {

    @IBOutlet private weak var view1: UIView!
    @IBOutlet private weak var view2: UIView!
    @IBOutlet private weak var view3: UIView!
    @IBOutlet private weak var view4: UIView!
    @IBOutlet private weak var view5: UIView!
    @IBOutlet private weak var view6: UIView!
    @IBOutlet private weak var view7: UIView!

    @IBAction func clickButton1(_ sender: Any) {
        UIView.transition(with: view1, duration: 1.0, options: [.transitionFlipFromLeft], animations: nil, completion: nil)
    }

    @IBAction func clickButton2(_ sender: Any) {
        UIView.transition(with: view2, duration: 1.0, options: [.transitionFlipFromRight], animations: nil, completion: nil)

    }

    @IBAction func clickButton3(_ sender: Any) {
        UIView.transition(with: view3, duration: 1.0, options: [.transitionFlipFromTop], animations: nil, completion: nil)
    }

    @IBAction func clickButton4(_ sender: Any) {
        UIView.transition(with: view4, duration: 1.0, options: [.transitionFlipFromBottom], animations: nil, completion: nil)
    }

    // isHiddenだとうまく表示されなかった
    @IBAction func clickButton5(_ sender: Any) {
        UIView.transition(with: view5, duration: 1.0, options: [.transitionCurlUp, .autoreverse], animations: {
            self.view5.alpha = 0.0
//            self.view5.isHidden = true
        }, completion: { _ in
            self.view5.alpha = 1.0
//            self.view5.isHidden = false
        })
    }

    @IBAction func clickButton6(_ sender: Any) {
        UIView.transition(with: view6, duration: 1.0, options: [.transitionCurlDown, .autoreverse], animations: nil, completion: nil)
    }

    // isHiddenだとうまく表示されなかった
    @IBAction func clickButton7(_ sender: Any) {
        UIView.transition(with: view7, duration: 1.0, options: [.transitionCrossDissolve, .autoreverse], animations: {
            self.view7.alpha = 0.0
//            self.view7.isHidden = true
        }, completion: { _ in
            self.view7.alpha = 1.0
//            self.view7.isHidden = false
        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // UIView.transitionは遷移メソッドなので、AnimationのようにviewDidAppearとかで使ってはいけない
        // ボタンアクションなどで利用するようにする
    }
}
