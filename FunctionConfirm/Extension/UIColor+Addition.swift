//
//  UIColor+Addition.swift
//  FunctionConfirm
//
//  Created by Maki, Yusaku | Mackey | ECID on 8/8/18.
//  Copyright © 2018 牧宥作. All rights reserved.
//

import UIKit

extension UIColor {

    public convenience init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
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
