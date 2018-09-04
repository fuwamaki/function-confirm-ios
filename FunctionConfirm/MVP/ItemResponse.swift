//
//  ItemResponse.swift
//  FunctionConfirm
//
//  Created by Maki, Yusaku | Mackey | ECID on 2018/09/04.
//  Copyright © 2018年 牧宥作. All rights reserved.
//

import Foundation

struct ItemResponse: Decodable {
    let status: Int
    let data: [Item]
    
    private enum CodingKeys: String, CodingKey {
        case status = "status"
        case data = "data"
    }
}
