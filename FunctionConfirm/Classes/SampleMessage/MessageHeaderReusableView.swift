//
//  MessageHeaderReusableView.swift
//  FunctionConfirm
//
//  Created by yusaku maki on 2021/10/09.
//  Copyright © 2021 fuwamaki. All rights reserved.
//

import UIKit
import MessageKit

class MessageHeaderReusableView: MessageReusableView {

    static var width: CGFloat = 128.0
    static var height: CGFloat = 48.0

    static var insets: UIEdgeInsets {
        return UIEdgeInsets(
            top: 12.0,
            left: (UIScreen.main.bounds.width-width)/2,
            bottom: 12.0,
            right: (UIScreen.main.bounds.width-width)/2)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addSubview(label)
    }

    private lazy var label: UILabel = {
        let frame = bounds.inset(by: MessageHeaderReusableView.insets)
        label = UILabel(frame: frame)
        label.preferredMaxLayoutWidth = frame.width
        label.numberOfLines = 1
        label.textAlignment = .center
        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        label.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        label.layer.cornerRadius = 12
        label.clipsToBounds = true
        return label
    }()

    public func render(text: String) {
        let text = (text == Date().kanjiyyyyMMddE) ? "今日" : text
        label.attributedText = NSAttributedString(
            string: text,
            attributes: [.font: UIFont.systemFont(ofSize: 12),
                         .foregroundColor: UIColor.white])
    }
}
