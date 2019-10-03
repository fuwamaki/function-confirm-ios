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

    @IBInspectable var notSelectedText: String = Text.notSelected
    @IBInspectable var selectedText: String = Text.selected
    @IBInspectable var iconImage: UIImage = UIImage()

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
        setupView()
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupView()
        setNeedsDisplay()
    }

    private func setupView() {
        layer.shadowColor = UIColor(hex: "#E84855").cgColor
        layer.borderColor = UIColor(hex: "#E84855").cgColor
        layer.borderWidth = 1.0
        layer.cornerRadius = 4.0
        layer.shadowOpacity = 1.0 // 影を表示する
        layer.shadowRadius = 0.0
        layer.backgroundColor = UIColor(hex: "#FFFFFF").cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 2.0)

        self.addSubview(stackView)
        stackView.addArrangedSubview(iconImageView)
        stackView.addArrangedSubview(textLabel)
        stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20.0).isActive = true
        stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }

    override var isHighlighted: Bool {
        didSet {
            layer.position = CGPoint(x: originalX, y: isHighlighted ? originalY+2.0 : originalY)
            layer.shadowOffset = isHighlighted ? CGSize(width: 0.0, height: 0.0) : CGSize(width: 0.0, height: 2.0)
        }
    }
}

extension RoundedCornerButton {
    func setStatus(_ status: Bool) {
        selectedStatus = status
        layer.backgroundColor = status ? UIColor(hex: "#EDEDED").cgColor : UIColor(hex: "#FFFFFF").cgColor
        textLabel.text = status ? selectedText : notSelectedText
        layer.shadowColor = status ? UIColor(hex: "#BFBFBF").cgColor : UIColor(hex: "#E84855").cgColor
        layer.borderColor = status ? UIColor.clear.cgColor : UIColor(hex: "#E84855").cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: status ? 3.0 : 2.0)
    }
}
