//
//  SemiModalCustomView.swift
//  FunctionConfirm
//
//  Created by yusaku maki on 2020/04/07.
//  Copyright © 2020 牧宥作. All rights reserved.
//

import UIKit

class SemiModalCustomView: UIView {
    override var intrinsicContentSize: CGSize {
        return CGSize(width: width, height: height)
    }

    var width: CGFloat = 0 {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    var height: CGFloat = 0 {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
}
