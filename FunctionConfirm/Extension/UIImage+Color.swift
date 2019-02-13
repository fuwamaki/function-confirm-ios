//
//  UIImage+color.swift
//  FunctionConfirm
//
//  Created by Maki, Yusaku | Mackey | ECID on 2019/01/04.
//  Copyright © 2019年 牧宥作. All rights reserved.
//

import UIKit

extension UIImage {

    static func image(color: UIColor) -> UIImage {
        // 1x1のbitmapを作成
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        guard let context = UIGraphicsGetCurrentContext() else {
            assertionFailure()
            return UIImage()
        }
        // bitmapを塗りつぶし
        context.setFillColor(color.cgColor)
        context.fill(rect)
        // UIImageに変換
        guard let image: UIImage = UIGraphicsGetImageFromCurrentImageContext() else {
            assertionFailure()
            return UIImage()
        }
        UIGraphicsEndImageContext()
        return image
    }
}
