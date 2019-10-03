//
//  RoundedCornerButton.swift
//  FunctionConfirm
//
//  Created by yusaku maki on 2019/10/02.
//  Copyright © 2019 牧宥作. All rights reserved.
//

import UIKit

private struct Text {
    static let notSelected = "未選択"
    static let selected = "選択済み"
}

@IBDesignable
final class RoundedCornerButton: UIButton {

    @IBInspectable var iconImage: UIImage = UIImage()
    @IBInspectable var notSelectedText: String = Text.notSelected
    @IBInspectable var selectedText: String = Text.selected

    @IBInspectable var notSelectedBackgroundColor: UIColor = UIColor.systemTeal
    @IBInspectable var notSelectedShadowColor: UIColor =  UIColor.ocean
    @IBInspectable var notSelectedBorderColor: UIColor = UIColor.clear
    @IBInspectable var selectedBackgroundColor: UIColor = UIColor.baseGray
    @IBInspectable var selectedShadowColor: UIColor = UIColor.gray
    @IBInspectable var selectedBorderColor: UIColor = UIColor.clear

    private(set) var selectedStatus: Bool = false

    private lazy var originalX: CGFloat = {
        return self.layer.position.x
    }()

    private lazy var originalY: CGFloat = {
        return self.layer.position.y
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        stackView.translatesAutoresizingMaskIntoConstraints = false // autoLayoutをONに
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.axis = .horizontal
        stackView.spacing = 4.0
        stackView.backgroundColor = UIColor.clear
        stackView.isUserInteractionEnabled = false // stackView部分をタップしてもボタンが反映するように
        return stackView
    }()

    private lazy var iconImageView: UIImageView = {
        let iconImageView = UIImageView(image: iconImage)
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.widthAnchor.constraint(equalToConstant: 32.0).isActive = true
        return iconImageView
    }()

    private lazy var textLabel: UILabel = {
        let width = stackView.frame.width - iconImageView.frame.width
        let textLabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: frame.height))
        textLabel.text = notSelectedText
        textLabel.textAlignment = .center
        textLabel.textColor = UIColor(hex: "#4A4A4A")
        textLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
        return textLabel
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        setupLayer()
        setupViews()
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupLayer()
        setupViews()
        setNeedsDisplay()
    }

    override var isHighlighted: Bool {
        didSet {
            layer.position = CGPoint(x: originalX, y: isHighlighted ? originalY+2.0 : originalY)
            layer.shadowOffset = isHighlighted ? CGSize(width: 0.0, height: 0.0) : CGSize(width: 0.0, height: 2.0)
        }
    }

    private func setupLayer() {
        setStatus(selectedStatus)
        layer.borderWidth = 1.0
        layer.cornerRadius = 4.0
        layer.shadowOpacity = 1.0 // 影を表示する
        layer.shadowRadius = 0.0 // ぼやけ影を非表示
    }

    private func setupViews() {
        self.addSubview(stackView)
        stackView.addArrangedSubview(iconImageView)
        stackView.addArrangedSubview(textLabel)
        stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20.0).isActive = true
        stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
}

// MARK: public
extension RoundedCornerButton {
    func setStatus(_ status: Bool) {
        selectedStatus = status
        layer.backgroundColor = status ? selectedBackgroundColor.cgColor : notSelectedBackgroundColor.cgColor
        layer.shadowColor = status ? selectedShadowColor.cgColor : notSelectedShadowColor.cgColor
        layer.borderColor = status ? selectedBorderColor.cgColor : notSelectedBorderColor.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: status ? 3.0 : 2.0) // 影の長さ
        textLabel.text = status ? selectedText : notSelectedText
    }
}
