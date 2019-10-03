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
        let stackView = UIStackView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        stackView.translatesAutoresizingMaskIntoConstraints = false // autoLayoutをONに
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.axis = .horizontal
        stackView.spacing = 4.0
        return stackView
    }()

    private lazy var iconImageView: UIImageView = {
        let iconImageView = UIImageView(image: iconImage)
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.widthAnchor.constraint(equalToConstant: 32.0).isActive = true
        return iconImageView
    }()

    private lazy var textLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.text = text
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

        self.addSubview(stackView)
        stackView.addArrangedSubview(iconImageView)
        stackView.addArrangedSubview(textLabel)
        stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true

        [UIControl.State.normal, UIControl.State.highlighted, UIControl.State.selected].forEach { state in
            switch state {
            case .normal:
                backgroundColor = UIColor(hex: "#FFFFFF")
                layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            case .highlighted:
                layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
            case .selected:
                backgroundColor = UIColor(hex: "#EDEDED")
                layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
            default:
                break
            }
        }
    }

//    override func backgroundImage(for state: UIControl.State) -> UIImage? {
//        switch state {
//        // style: .filled
//        case .highlighted:
//            return loadBackgroundImage(name: "button_style_filled", opacity: Constant.highlightOpacity)
//        case .disabled:
//            return loadBackgroundImage(name: "button_style_filled", tint: ColorPalette.backgroundGray)
//        default:
//            return loadBackgroundImage(name: "button_style_filled", tint: tintColor)
//        }
//    }
//
//    private func loadBackgroundImage(name: String, opacity: CGFloat? = nil, tint color: UIColor? = nil) -> UIImage? {
//        var image = UIImage(named: name, in: Bundle(for: type(of: self)), compatibleWith: traitCollection)
//        if let opacity = opacity {
//            image = image?.withOpacity(opacity: opacity)
//        }
//        if let color = color {
//            image = image?.tinted(color: color)
//        }
//        return image?.resizableImage(withCapInsets: Constant.backgroundInsets)
//    }
//
//    override func titleColor(for state: UIControl.State) -> UIColor {
//        switch state {
//        case .highlighted:
//            return ColorPalette.textWhite.withAlphaComponent(Constant.highlightOpacity)
//        default:
//            return ColorPalette.textWhite
//        }
//    }
}
