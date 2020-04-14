//
//  SemiModalHeight.swift
//  FunctionConfirm
//
//  Created by yusaku maki on 2020/04/14.
//  Copyright © 2020 牧宥作. All rights reserved.
//

import UIKit

enum SemiModalHeight: Equatable {
    case maxHeight
    case maxHeightWithTopInset(CGFloat)
    case contentHeight(CGFloat)
    case contentHeightIgnoringSafeArea(CGFloat)
    case intrinsicHeight
}
