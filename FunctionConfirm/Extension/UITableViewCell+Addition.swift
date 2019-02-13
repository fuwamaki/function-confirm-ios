//
//  UITableViewCell+Addition.swift
//  FunctionConfirm
//
//  Created by Maki, Yusaku | Mackey | ECID on 8/8/18.
//  Copyright © 2018 牧宥作. All rights reserved.
//

import UIKit

extension UITableViewCell {

    class func defaultHeight(_ tableView: UITableView) -> CGFloat {
        return 44.0
    }

    class var defaultReuseIdentifier: String {
        return String(describing: self)
    }
}
