//
//  Item.swift
//  FunctionConfirm
//
//  Created by Maki, Yusaku | Mackey | ECID on 8/9/18.
//  Copyright © 2018 牧宥作. All rights reserved.
//

import Foundation

struct Item: Codable {
    var id: Int = 0
    var itemId: String? = "99"
    let name: String
    let category: String
    let price: Int
}
