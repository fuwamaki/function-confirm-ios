//
//  HalfModalHeight.swift
//  FunctionConfirm
//
//  Created by yusaku maki on 2020/04/14.
//  Copyright © 2020 牧宥作. All rights reserved.
//

import UIKit

public enum HalfModalHeight: Equatable {
    case maxHeight
    case maxHeightWithTopInset(CGFloat)
    case contentHeight(CGFloat)
    case contentHeightIgnoringSafeArea(CGFloat)
    case intrinsicHeight
}
