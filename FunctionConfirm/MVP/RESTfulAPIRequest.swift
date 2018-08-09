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

struct GetItemRequest: APIRequest {
    typealias Response = [Item]
    let method: HTTPMethod = .get
    let path: String = "/api/v2/items"
    let parameters: Any = ["page":"1","per_page":"10"]
}

struct PostItemRequest: APIRequest {
    //ココはItemじゃない何か
    typealias Response = Item
    let method: HTTPMethod = .post
    let path: String = ""
}

class RESTfulApiRequest {

    private weak var task: URLSessionDataTask?

    func getAPI(completion: @escaping (Result<GetItemRequest.Response, NSError>) -> Void) {
        let request = GetItemRequest()
        Session.send(request) { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error as NSError))
            }
        }
    }

    func postAPI(item: Item, completion: @escaping (Result<Void, NSError>) -> Void) {
        let request = PostItemRequest()
        Session.send(request) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error as NSError))
            }
        }
    }
}
