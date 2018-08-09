//
//  RESTfulAPIRequest.swift
//  FunctionConfirm
//
//  Created by Maki, Yusaku | Mackey | ECID on 8/9/18.
//  Copyright © 2018 牧宥作. All rights reserved.
//

import APIKit
import Result

protocol APIRequest: Request {
}

extension APIRequest {

    var baseURL: URL {
        return URL(string: "https://qiita.com")!
    }
}

extension APIRequest where Response: Decodable {

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

struct Items: APIRequest {
    typealias Response = [Item]
    let method: HTTPMethod = .get
    let path: String = "/api/v2/items"
    let parameters: Any = ["page":"1","per_page":"10"]
}

class RESTfulApiRequest {

    private weak var task: URLSessionDataTask?

    func getAPI(completion: @escaping (Result<Items.Response, NSError>) -> Void) {
        let request = Items()
        Session.send(request) { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error as NSError))
            }
        }
    }
}
