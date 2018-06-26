//
//  QiitaListElement.swift
//  FunctionConfirm
//
//  Created by y-maki on 2018/06/26.
//  Copyright © 2018年 牧宥作. All rights reserved.
//

import Foundation
import APIKit

struct QiitaListElement: Decodable {
    let title: String
    let likesCount: Int
    let url: String
    
    private enum CodingKeys: String, CodingKey {
        case title = "title"
        case likesCount = "likes_count"
        case url = "url"
    }
}
