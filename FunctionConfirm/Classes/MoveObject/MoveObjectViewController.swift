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
        let aTouch: UITouch = touches.first!
        let location = aTouch.location(in: objectLabel)
        let prevLocation = aTouch.previousLocation(in: objectLabel)
        objectLabel.frame.origin.x += (location.x - prevLocation.x)
        objectLabel.frame.origin.y += (location.y - prevLocation.y)
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
