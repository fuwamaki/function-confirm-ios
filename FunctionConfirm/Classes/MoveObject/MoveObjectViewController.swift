//
//  MoveObjectViewController.swift
//  FunctionConfirm
//
//  Created by yusaku maki on 2021/10/03.
//  Copyright © 2021 fuwamaki. All rights reserved.
//

import UIKit

final class MoveObjectViewController: UIViewController {

    private lazy var objectLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        label.backgroundColor = .cyan
        label.text = "maru"
        label.textAlignment = .center
        label.center = view.center
        label.clipsToBounds = true
        label.layer.cornerRadius = 40.0
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(objectLabel)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touchesBegan")
        // Labelアニメーション.
        UIView.animate(withDuration: 0.06) {
            self.objectLabel.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touchesMoved")
        // タッチイベントを取得.
        let aTouch: UITouch = touches.first!
        // 移動した先の座標を取得.
        let location = aTouch.location(in: self.objectLabel)
        // 移動する前の座標を取得.
        let prevLocation = aTouch.previousLocation(in: self.objectLabel)
        // CGRect生成.
        var myFrame: CGRect = self.objectLabel.frame
        // ドラッグで移動したx, y距離をとる.
        let deltaX: CGFloat = location.x - prevLocation.x
        let deltaY: CGFloat = location.y - prevLocation.y
        // 移動した分の距離をmyFrameの座標にプラスする.
        myFrame.origin.x += deltaX
        myFrame.origin.y += deltaY
        // frameにmyFrameを追加.
        self.objectLabel.frame = myFrame
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touchesEnded")
        UIView.animate(withDuration: 0.1) {
            // 拡大用アフィン行列を作成する.
            self.objectLabel.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
            // 縮小用アフィン行列を作成する.
            self.objectLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
    }
}
