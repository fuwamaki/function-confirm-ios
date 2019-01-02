//
//  StoryboardLoadable.swift
//  FunctionConfirm
//
//  Created by Maki, Yusaku | Mackey | ECID on 2019/01/03.
//  Copyright © 2019年 牧宥作. All rights reserved.
//

import UIKit

protocol StoryboardLoadable {
    static var storyboardName: UIStoryboard.Name { get }
    static var storyboardIdentifier: String { get }
    static func instantiateFromStoryboard() -> Self
}

extension StoryboardLoadable where Self: UIViewController {

    /// instantiateFromStoryboardByFileNameを使用する場合は、
    /// UIViewControllerでは実装不要なので追加しています。
    static var storyboardName: UIStoryboard.Name {
        return UIStoryboard.Name(rawValue: "dummy")!
    }

    static var storyboardIdentifier: String {
        return String(describing: self)
    }

    static func instantiateFromStoryboard() -> Self {
        let storyboard = UIStoryboard(name: storyboardName.rawValue, bundle: Bundle(for: self))
        return storyboard.instantiateViewController(withIdentifier: storyboardIdentifier) as! Self
    }

    /// 同名のファイル名のStoryboardからUIViewControllerを取得します。
    /// Storyboard上で、該当のUIViewControllerのisInitialViewControllerがtrueになっている必要があります。
    ///
    /// - Returns: UIViewController
    static func instantiateFromStoryboardByFileName() -> Self {
        let storyboard = UIStoryboard(name: String(describing: self), bundle: Bundle(for: self))
        return storyboard.instantiateInitialViewController() as! Self
    }
}
