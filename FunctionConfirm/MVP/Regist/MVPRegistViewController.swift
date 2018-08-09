//
//  MVPRegistViewController.swift
//  FunctionConfirm
//
//  Created by Maki, Yusaku | Mackey | ECID on 8/8/18.
//  Copyright © 2018 牧宥作. All rights reserved.
//

import UIKit
import Cartography

class MVPRegistViewController: UIViewController {

    private struct Text {
        static let title = "商品登録"
        static let close = "戻る"
    }

    private let itemNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.textColor = UIColor.black
        label.backgroundColor = UIColor.red
        label.text = "てすと"
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = Text.title
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: Text.close, style: .plain, target: self, action: #selector(close(_:)))
        view.backgroundColor = UIColor.white
    }

    override func viewDidLayoutSubviews() {
        // MEMO: viewDidLayoutSubviews内じゃないとview.safeAreaInsets.topの値を取得できない
        setLabels(view.safeAreaInsets.top)
    }

    @objc func close(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    private func setLabels(_ topMargin: CGFloat) {
        view.addSubview(itemNameLabel)
        constrain(itemNameLabel) { label in
            label.width == 100
            label.height == 50
            label.top == label.superview!.top + topMargin
            label.left == label.superview!.left
        }
    }
}
