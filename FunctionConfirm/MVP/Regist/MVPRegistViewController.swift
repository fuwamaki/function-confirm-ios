//
//  MVPRegistViewController.swift
//  FunctionConfirm
//
//  Created by Maki, Yusaku | Mackey | ECID on 8/8/18.
//  Copyright © 2018 牧宥作. All rights reserved.
//

import UIKit
import Cartography
import KRProgressHUD

protocol MVPRegistView: class {
    func close()
}

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

class MVPRegistViewController: UIViewController, MVPRegistView {

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
        textField.textAlignment = .right

        textField.borderStyle = .none
        textField.layer.cornerRadius = 5
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth  = 1

        // MEMO: padding.right
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 32))
        textField.rightViewMode = .always
        return textField
    }()

    private lazy var categoryTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 14.0)
        textField.textColor = UIColor.black
        textField.placeholder = Text.categoryPlaceholder
        textField.textAlignment = .right

        textField.borderStyle = .none
        textField.layer.cornerRadius = 5
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth  = 1
        
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 32))
        textField.rightViewMode = .always
        return textField
    }()

    private lazy var priceTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 14.0)
        textField.textColor = UIColor.black
        textField.placeholder = Text.pricePlaceholder
        textField.textAlignment = .right

        textField.borderStyle = .none
        textField.layer.cornerRadius = 5
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth  = 1
        
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 32))
        textField.rightViewMode = .always
        return textField
    }()

    private lazy var registButton: UIButton = {
        let button = UIButton()
        button.setTitle(Text.regist, for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        button.backgroundColor = UIColor.red
        button.addTarget(self, action: #selector(touchDownButton), for: .touchDown)
        button.addTarget(self, action: #selector(touchUpInsideButton), for: .touchUpInside)
        return button
    }()

    private var presenter: MVPRegistPresentable!

    init() {
        super.init(nibName: nil, bundle: nil)
        presenter = MVPRegistPresenter.init(self)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        presenter = MVPRegistPresenter.init(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = Text.title
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: Text.close, style: .plain, target: self, action: #selector(close))
        view.backgroundColor = UIColor.white
    }

    override func viewDidLayoutSubviews() {
        // MEMO: viewDidLayoutSubviews内じゃないとview.safeAreaInsets.topの値を取得できない
        setViews(view.safeAreaInsets.top)
    }

    @objc func close() {
        KRProgressHUD.dismiss()
        dismiss(animated: true, completion: nil)
    }

    @objc private func touchDownButton() {
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseIn, animations: {() -> Void in
            self.registButton.alpha = 0.7
        }, completion: nil)
    }

    @objc private func touchUpInsideButton() {
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseIn, animations: {() -> Void in
            self.registButton.alpha = 1
        }, completion: nil)
        if let name = nameTextField.text, let category = categoryTextField.text, let priceStr = priceTextField.text,
            name != "", category != "", let price = Int(priceStr) {
            showConfirmAlert(Item(id: 0, name: name, category: category, price: price))
        } else {
            showErrorAlert(message: "未入力です。")
        }
    }

    private func showConfirmAlert(_ item: Item) {
        let alert = UIAlertController(
            title: "登録します。よろしいですか？",
            message: "商品名: \(item.name)",
            preferredStyle: .alert)
        // TODO: 登録後の処理
        alert.addAction(UIAlertAction(title: "登録", style: .default, handler: { _ in
            KRProgressHUD.show()
            self.presenter.registerItem(item)
        }))
        alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel))
        self.present(alert, animated: true, completion: nil)
    }

    private func showErrorAlert(message: String) {
        let alert = UIAlertController(
            title: "エラー",
            message: message,
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "閉じる", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: setLayout

extension MVPRegistViewController {

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
            nameLabel.top == nameLabel.superview!.top + topMargin + 96
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
            nameTextField.top == nameTextField.superview!.top + topMargin + 96
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
