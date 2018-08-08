//
//  UITableView+Addition.swift
//  FunctionConfirm
//
//  Created by Maki, Yusaku | Mackey | ECID on 8/8/18.
//  Copyright © 2018 牧宥作. All rights reserved.
//

import UIKit

extension UITableView {
    
    func registerForCell<T>(_: T.Type) where T: UITableViewCell, T: NibLoadable {
        register(T.loadNib(), forCellReuseIdentifier: T.defaultReuseIdentifier)
    }
    
    func registerForCell<T>(_: T.Type) where T: UITableViewCell {
        register(T.self, forCellReuseIdentifier: T.defaultReuseIdentifier)
    }
    
    func registerForHeaderFooterView<T>(_: T.Type) where T: UITableViewHeaderFooterView, T: NibLoadable {
        register(T.loadNib(), forHeaderFooterViewReuseIdentifier: T.defaultReuseIdentifier)
    }
    
    func registerForHeaderFooterView<T>(_: T.Type) where T: UITableViewHeaderFooterView {
        register(T.self, forHeaderFooterViewReuseIdentifier: T.defaultReuseIdentifier)
    }
    
    func dequeueCellForIndexPath<T>(_ indexPath: IndexPath, identifier: String? = nil) -> T where T: UITableViewCell {
        let reuseIdentifier = identifier ?? T.defaultReuseIdentifier
        return dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! T
    }
}

