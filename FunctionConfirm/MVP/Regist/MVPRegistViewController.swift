//
//  MVPRegistViewController.swift
//  FunctionConfirm
//
//  Created by Maki, Yusaku | Mackey | ECID on 8/8/18.
//  Copyright © 2018 牧宥作. All rights reserved.
//

import UIKit
import Cartography

private struct Text {
    static let title = "商品登録"
    static let close = "戻る"
    static let name = "商品名"
    static let namePlaceholder = "商品名を入力"
    static let category = "カテゴリ"
    static let categoryPlaceholder = "カテゴリを選択"
    static let price = "価格"
    static let pricePlaceholder = "価格を入力"
    static let regist = "登録"
}

class MVPRegistViewController: UIViewController {

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.textColor = UIColor.black
        label.text = Text.name
        return label
    }()

    private lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.textColor = UIColor.black
        label.text = Text.category
        return label
    }()

    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.textColor = UIColor.black
        label.text = Text.price
        return label
    }()

    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 14.0)
        textField.textColor = UIColor.black
        textField.placeholder = Text.namePlaceholder
        return textField
    }()

    private lazy var categoryTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 14.0)
        textField.textColor = UIColor.black
        textField.placeholder = Text.categoryPlaceholder
        return textField
    }()

    private lazy var priceTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 14.0)
        textField.textColor = UIColor.black
        textField.placeholder = Text.pricePlaceholder
        return textField
    }()

    private lazy var registButton: UIButton = {
        let button = UIButton()
        button.setTitle(Text.regist, for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        button.backgroundColor = UIColor.red
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = Text.title
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: Text.close, style: .plain, target: self, action: #selector(close(_:)))
        view.backgroundColor = UIColor.white
    }

    override func viewDidLayoutSubviews() {
        // MEMO: viewDidLayoutSubviews内じゃないとview.safeAreaInsets.topの値を取得できない
        setViews(view.safeAreaInsets.top)
    }

    @objc func close(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    private func setViews(_ topMargin: CGFloat) {
        view.addSubview(nameLabel)
        view.addSubview(categoryLabel)
        view.addSubview(priceLabel)
        view.addSubview(nameTextField)
        view.addSubview(categoryTextField)
        view.addSubview(priceTextField)
        view.addSubview(registButton)
        constrain(nameLabel, categoryLabel, priceLabel) { nameLabel, categoryLabel, priceLabel in
            nameLabel.width == 64
            nameLabel.height == 32
            nameLabel.top == nameLabel.superview!.top + topMargin + 120
            nameLabel.left == nameLabel.superview!.left + 48
            categoryLabel.width == 64
            categoryLabel.height == 32
            categoryLabel.top == nameLabel.bottom + 48
            categoryLabel.left == categoryLabel.superview!.left + 48
            priceLabel.width == 64
            priceLabel.height == 32
            priceLabel.top == categoryLabel.bottom + 48
            priceLabel.left == priceLabel.superview!.left + 48
        }
        constrain(nameTextField, categoryTextField, priceTextField) { nameTextField, categoryTextField, priceTextField in
            nameTextField.width == 120
            nameTextField.height == 32
            nameTextField.top == nameTextField.superview!.top + topMargin + 120
            nameTextField.right == nameTextField.superview!.right - 48
            categoryTextField.width == 120
            categoryTextField.height == 32
            categoryTextField.top == nameTextField.bottom + 48
            categoryTextField.right == nameTextField.superview!.right - 48
            priceTextField.width == 120
            priceTextField.height == 32
            priceTextField.top == categoryTextField.bottom + 48
            priceTextField.right == nameTextField.superview!.right - 48
        }
        constrain(registButton) { button in
            button.height == 48
            button.left == button.superview!.left + 48
            button.right == button.superview!.right - 48
            button.bottom == button.superview!.bottom - 120
        }
    }
}
