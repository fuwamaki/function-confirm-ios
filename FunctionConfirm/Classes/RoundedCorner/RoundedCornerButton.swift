//
//  RoundedCornerButton.swift
//  FunctionConfirm
//
//  Created by yusaku maki on 2019/10/02.
//  Copyright © 2019 牧宥作. All rights reserved.
//

import UIKit

@IBDesignable
final class RoundedCornerButton: UIButton {

    @IBInspectable var text: String = ""
    @IBInspectable var iconImage: UIImage = UIImage()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        stackView.translatesAutoresizingMaskIntoConstraints = false // autoLayoutをONに
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.axis = .horizontal
        stackView.spacing = 4.0
        stackView.backgroundColor = UIColor.clear
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
        textLabel.text = text
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
        layer.shadowOpacity = 1.0
        layer.shadowRadius = 0.0
        layer.backgroundColor = UIColor(hex: "#FFFFFF").cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 2.0)

        self.addSubview(stackView)
        stackView.addArrangedSubview(iconImageView)
        stackView.addArrangedSubview(textLabel)
        stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true

        [UIControl.State.normal, UIControl.State.highlighted, UIControl.State.selected].forEach { state in
            let image = backgroundImage(for: state)
            setBackgroundImage(image, for: state)
        }
    }

    override func backgroundImage(for state: UIControl.State) -> UIImage? {
        switch state {
        case .normal:
//            layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            return UIColor(hex: "#FFFFFF").image
        case .highlighted:
//            layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
            return UIColor(hex: "#000000").image
        default:
//            layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
            return UIColor(hex: "#000000").image
        }
    }
}
