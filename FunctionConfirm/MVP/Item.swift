//
//  Item.swift
//  FunctionConfirm
//
//  Created by Maki, Yusaku | Mackey | ECID on 8/9/18.
//  Copyright © 2018 牧宥作. All rights reserved.
//

import Foundation

struct Item: Codable {
    let item_id: String? = "99"
    let name: String
    let category: String
    let price: Int

    private enum CodingKeys: String, CodingKey {
        case item_id = "item_id"
        case name = "name"
        case category = "category"
        case price = "price"
    }
}
