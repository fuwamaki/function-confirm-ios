//
//  AnimationSeventhViewController.swift
//  FunctionConfirm
//
//  Created by Maki, Yusaku | Mackey | ECID on 2019/02/17.
//  Copyright © 2019年 牧宥作. All rights reserved.
//

import UIKit

final class AnimationSeventhViewController: UIViewController {

    @IBOutlet private weak var view1: UIView!

    // UIBezierPathの描画アニメーションをCoreAnimationで実現
    @IBAction func clickButton1(_ sender: Any) {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: view.frame.maxX, y: view.frame.minY))
        path.addLine(to: CGPoint(x: view.frame.minX, y: view.frame.maxY))
        path.lineWidth = 1.0
        let lineLayer = CAShapeLayer()
        lineLayer.strokeColor = UIColor.blue.cgColor
        lineLayer.lineWidth = 1.0
        lineLayer.path = path.cgPath

        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = 1.0
        animation.timingFunction = CAMediaTimingFunction(name: .easeIn) // タイミング曲線
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.isRemovedOnCompletion = false

        view.layer.addSublayer(lineLayer)
        lineLayer.add(animation, forKey: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
