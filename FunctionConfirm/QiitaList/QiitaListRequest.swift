//
//  QiitaListRequest.swift
//  FunctionConfirm
//
//  Created by y-maki on 2018/06/26.
//  Copyright © 2018年 牧宥作. All rights reserved.
//

import Foundation
import APIKit

protocol QiitaListRequest: Request {
}

extension QiitaListRequest {
    var baseURL: URL {
        return URL(string: "https://qiita.com")!
    }
}

extension QiitaListRequest where Response: Decodable {
    var dataParser: DataParser {
        return DecodableDataParser()
    }

    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        guard let data = object as? Data else {
            throw ResponseError.unexpectedObject(object)
        }
        return try JSONDecoder().decode(Response.self, from: data)
    }
}
