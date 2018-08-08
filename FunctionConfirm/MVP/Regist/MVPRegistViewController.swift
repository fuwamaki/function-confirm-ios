//
//  MVPRegistViewController.swift
//  FunctionConfirm
//
//  Created by Maki, Yusaku | Mackey | ECID on 8/8/18.
//  Copyright © 2018 牧宥作. All rights reserved.
//

import UIKit

class MVPRegistViewController: UIViewController {

    private struct Text {
        static let title = "商品登録"
        static let close = "戻る"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = Text.title
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: Text.close, style: .plain, target: self, action: #selector(close(_:)))
        view.backgroundColor = UIColor.white
    }

    @objc func close(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}
