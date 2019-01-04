//
//  SubmitButton.swift
//  FunctionConfirm
//
//  Created by Maki, Yusaku | Mackey | ECID on 2019/01/04.
//  Copyright © 2019年 牧宥作. All rights reserved.
//

import UIKit

@IBDesignable
class SubmitButton: UIButton {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setup()
    }

    func setup() {
        layer.cornerRadius = 5
        [UIControlState.normal, UIControlState.highlighted, UIControlState.disabled].forEach { state in
            switch state {
            case .normal:
                setTitleColor(UIColor.white, for: state)
                setBackgroundImage(UIImage.image(color: UIColor.red), for: state)
            case .highlighted:
                setTitleColor(UIColor.white.withAlphaComponent(0.5), for: state)
                setBackgroundImage(UIImage.image(color: UIColor.red), for: state)
            case .disabled:
                setTitleColor(UIColor.white, for: state)
                setBackgroundImage(UIImage.image(color: UIColor.gray), for: state)
            default:
                break
            }
        }
    }
}
