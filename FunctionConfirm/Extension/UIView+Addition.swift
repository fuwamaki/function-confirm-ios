//
//  UIView+Addition.swift
//  FunctionConfirm
//
//  Created by yusaku maki on 2022/01/20.
//  Copyright © 2022 fuwamaki. All rights reserved.
//

import UIKit

extension UIView {
    func fitConstraintsContentView(view: UIView? = nil) {
        if let contentView = view == nil ? subviews.first : view {
            NSLayoutConstraint.activate([
                contentView.topAnchor.constraint(equalTo: self.topAnchor),
                contentView.leftAnchor.constraint(equalTo: self.leftAnchor),
                contentView.rightAnchor.constraint(equalTo: self.rightAnchor),
                contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ])
        }
    }
}
