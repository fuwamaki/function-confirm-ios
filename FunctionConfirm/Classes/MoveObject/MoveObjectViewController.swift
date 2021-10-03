//
//  MoveObjectViewController.swift
//  FunctionConfirm
//
//  Created by yusaku maki on 2021/10/03.
//  Copyright © 2021 fuwamaki. All rights reserved.
//

import UIKit
import PencilKit

final class MoveObjectViewController: UIViewController {

    private lazy var objectLabel: UIView = {
        let label = UIView(frame: CGRect(x: 40, y: 200, width: 80, height: 80))
        label.layer.borderColor = UIColor.red.cgColor
        label.layer.borderWidth = 10.0
        label.backgroundColor = .clear
        label.clipsToBounds = true
        label.layer.cornerRadius = 40.0
        return label
    }()

    // 物体を動かせるかどうか
    private var isObjectMoving: Bool = false
    // ペンを書けるかどうか（一筆書き）
    private var isPencilMode: Bool = true {
        didSet {
            if !isPencilMode {
                view.addSubview(objectLabel)
                canvasView.isUserInteractionEnabled = false
            }
        }
    }

    private lazy var canvasView: CustomCanvasView = {
        let canvasView = CustomCanvasView(frame: view.frame)
        canvasView.drawingPolicy = .anyInput
        canvasView.delegate = self
        canvasView.tool = PKInkingTool(.pen, color: .orange, width: 5)
        return canvasView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(canvasView)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        print("touchesBegan")
        let aTouch: UITouch = touches.first!
        let touchPoint = aTouch.location(in: view) // view上におけるタッチ位置
        isObjectMoving = objectLabel.frame.minX < touchPoint.x
            && touchPoint.x < objectLabel.frame.maxX
            && objectLabel.frame.minY < touchPoint.y
            && touchPoint.y < objectLabel.frame.maxY
        // Labelアニメーション.
        UIView.animate(withDuration: 0.06) {
            self.objectLabel.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isObjectMoving else { return }
//        print("touchesMoved")
        let aTouch: UITouch = touches.first!
        let location = aTouch.location(in: objectLabel) // objectLabelの移動後位置
        let prevLocation = aTouch.previousLocation(in: objectLabel) // objectLabelの移動前位置
        objectLabel.frame.origin.x += (location.x - prevLocation.x)
        objectLabel.frame.origin.y += (location.y - prevLocation.y)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        print("touchesEnded")
        isObjectMoving = false
        UIView.animate(withDuration: 0.1) {
            // 拡大用アフィン行列を作成する.
            self.objectLabel.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
            // 縮小用アフィン行列を作成する.
            self.objectLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
    }
}

// MARK: PKCanvasViewDelegate
extension MoveObjectViewController: PKCanvasViewDelegate {
    func canvasViewDidEndUsingTool(_ canvasView: PKCanvasView) {
//        print("canvasViewDidEndUsingTool")
        isPencilMode = false
    }
}
