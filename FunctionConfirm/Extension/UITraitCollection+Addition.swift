//
//  UITraitCollection+Addition.swift
//  FunctionConfirm
//
//  Created by yusaku maki on 2022/01/20.
//  Copyright © 2022 fuwamaki. All rights reserved.
//

import UIKit

extension UITraitCollection {
    static var isDarkMode: Bool {
        return current.userInterfaceStyle == .dark
    }
}
