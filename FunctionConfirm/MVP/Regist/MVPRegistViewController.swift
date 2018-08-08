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

    private var itemNameLabel: UILabel

    private struct Text {
        static let title = "商品登録"
        static let close = "戻る"
    }

    init() {
        itemNameLabel = UILabel()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = Text.title
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: Text.close, style: .plain, target: self, action: #selector(close(_:)))
        view.backgroundColor = UIColor.white
        setLabels()
    }

    @objc func close(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    private func setLabels() {
        itemNameLabel.font = UIFont.systemFont(ofSize: 14.0)
        itemNameLabel.textColor = UIColor.black
        itemNameLabel.backgroundColor = UIColor.red
        itemNameLabel.text = "てすと"
        view.addSubview(itemNameLabel)
        constrain(itemNameLabel) { label in
            label.width == 100
            label.height == 50
            label.top == label.superview!.top + 300
            label.left == label.superview!.left
        }
    }
}
