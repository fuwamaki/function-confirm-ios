//
//  UIColor+Addition.swift
//  FunctionConfirm
//
//  Created by Maki, Yusaku | Mackey | ECID on 8/8/18.
//  Copyright © 2018 牧宥作. All rights reserved.
//

import UIKit

extension UIColor {

    public convenience init(hex: String, alpha: CGFloat = 1.0) {
        let v = Int("000000" + hex, radix: 16) ?? 0
        let r = CGFloat(v / Int(powf(256, 2)) % 256) / 255
        let g = CGFloat(v / Int(powf(256, 1)) % 256) / 255
        let b = CGFloat(v / Int(powf(256, 0)) % 256) / 255
        self.init(red: r, green: g, blue: b, alpha: min(max(alpha, 0), 1))
    }

    class var white: UIColor {
        return UIColor(hex: "#ffffff")
    }

    class var baseGray: UIColor {
        return UIColor(hex: "#EFEFF4")
    }

    class var gray: UIColor {
        return UIColor(hex: "#c5c5c5")
    }

    class var black: UIColor {
        return UIColor(hex: "#212121")
    }

    class var red: UIColor {
        return UIColor(hex: "#fa4141")
    }

    class var orange: UIColor {
        return UIColor(hex: "#ff7f00")
    }

    class var yellow: UIColor {
        return UIColor(hex: "#facd00")
    }

    class var green: UIColor {
        return UIColor(hex: "#41c823")
    }

    class var blue: UIColor {
        return UIColor(hex: "#2891ff")
    }

    class var purple: UIColor {
        return UIColor(hex: "#915aff")
    }

    class var pink: UIColor {
        return UIColor(hex: "#ff649b")
    }

    class var ocean: UIColor {
        return UIColor(hex: "#5271ff")
    }

    // UIColorをUIImage化するextension
    public var image: UIImage? {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        context.setFillColor(self.cgColor)
        context.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
