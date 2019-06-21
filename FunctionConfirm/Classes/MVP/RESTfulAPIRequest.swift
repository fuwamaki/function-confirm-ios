//
//  RESTfulAPIRequest.swift
//  FunctionConfirm
//
//  Created by Maki, Yusaku | Mackey | ECID on 8/9/18.
//  Copyright © 2018 牧宥作. All rights reserved.
//

import APIKit

protocol APIRequest: Request {
}

extension APIRequest {

    var baseURL: URL {
        return URL(string: "https://item-server.herokuapp.com")!
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
    typealias Response = ItemResponse
    let method: HTTPMethod = .get
    let path: String = "/items"
}

struct PostItemRequest: APIRequest {
    typealias Response = Item
    let data: [String: Any]
    let method: HTTPMethod = .post
    let path: String = "/create"
    var bodyParameters: BodyParameters? {
        return JSONBodyParameters(JSONObject: data)
    }
}

struct ItemDeleteResponse: Decodable {
    let status: String?
}

struct DeleteItemRequest: APIRequest {
    typealias Response = ItemDeleteResponse
    let method: HTTPMethod = .delete
    let path: String = "/delete"
    let id: Int
    var queryParameters: [String: Any]? {
        return ["id": id]
    }
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

    func postAPI(item: Item, completion: @escaping (Result<PostItemRequest.Response, NSError>) -> Void) {
        let itemRequest = ItemRequest(item: item)
        let data = try! JSONEncoder().encode(itemRequest)
        print(String(data: data, encoding: String.Encoding.utf8)!)
        let request = PostItemRequest(data: parse(data: data))
        Session.send(request) { result in
            switch result {
            case .success(let response):
                print(response)
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error as NSError))
            }
        }
    }

    func deleteAPI(_ id: Int, _ completion: @escaping (Result<DeleteItemRequest.Response, NSError>) -> Void) {
        Session.send(DeleteItemRequest(id: id)) { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error as NSError))
            }
        }
    }

    func parse(data: Data) -> [String: Any] {
        do {
            let json = try JSONSerialization.jsonObject(with: data) as! [String: Any]
            print(json)
            return json
        } catch {
            fatalError("json parse error")
        }
    }
}
