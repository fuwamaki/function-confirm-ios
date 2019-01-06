//
//  ItemAPIRequestRx.swift
//  FunctionConfirm
//
//  Created by Maki, Yusaku | Mackey | ECID on 2018/12/30.
//  Copyright © 2018年 牧宥作. All rights reserved.
//

import Foundation
import RxSwift

enum ItemAPIRequestError: Error {
    case invalidRequest
    case responseFailure
    case notAvailable

    var message: String {
        switch self {
        case .invalidRequest:
            return "入力内容に誤りがあります。"
        case .responseFailure:
            return "エラーが発生しました。しばらく経ってからやり直してください。"
        case .notAvailable:
            return "現在利用できません。"
        }
    }
}

private struct Url {
    static let baseURLString = "https://item-server.herokuapp.com"
    static let getItemsURL: URL = URL(string: Url.baseURLString + "/items")!
    static var postItemURL: URL = URL(string: Url.baseURLString + "/create")!
    static var putItemURL: URL = URL(string: Url.baseURLString + "/update")!
    static var deleteItemURL: URL = URL(string: Url.baseURLString + "/delete")!
}

struct GetItemResponseRx: Decodable {
    let status: Int
    let data: [ItemRx]
}

struct PostItemRequestRx: Codable {
    let item: ItemRx
}

struct DeleteItemResponseRx: Decodable {
    let status: Int
}

class ItemAPIRequestRx {

    enum ItemAPIError: Error {
        case jsonParseError
        case invalidRequest
        case serverError
    }

    func getItemsAPI() -> Single<GetItemResponseRx> {
        return Single<GetItemResponseRx>.create(subscribe: { single in
            let task = URLSession.shared.dataTask(with: Url.getItemsURL) {data, response, error in
                if let error = error {
                    single(.error(error))
                    return
                }
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    single(.error(ItemAPIError.serverError))
                    return
                }
                guard let data = data else {
                    single(.error(ItemAPIError.jsonParseError))
                    return
                }
                do {
                    let responseData = try JSONDecoder().decode(GetItemResponseRx.self, from: data)
                    single(.success(responseData))
                } catch {
                    single(.error(ItemAPIError.jsonParseError))
                }
            }
            task.resume()
            return Disposables.create()
        })
    }

    func postItemAPI(item: ItemRx) -> Single<ItemRx> {
        guard let data = try? JSONEncoder().encode(PostItemRequestRx(item: item)) else {
            return Single.error(ItemAPIError.invalidRequest)
        }
        return Single<ItemRx>.create(subscribe: { single in
            var request = URLRequest(url: Url.postItemURL)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = data
            let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
                if let error = error {
                    single(.error(error))
                    return
                }
                guard let response = response as? HTTPURLResponse, response.statusCode == 201 else {
                    single(.error(ItemAPIError.serverError))
                    return
                }
                guard let data = data else {
                    single(.error(ItemAPIError.jsonParseError))
                    return
                }
                do {
                    let responseData = try JSONDecoder().decode(ItemRx.self, from: data)
                    single(.success(responseData))
                } catch {
                    single(.error(ItemAPIError.jsonParseError))
                }
            })
            task.resume()
            return Disposables.create()
        })
    }

    func putItemAPI(itemId: Int, item: ItemRx) -> Single<ItemRx> {
        guard let data = try? JSONEncoder().encode(PostItemRequestRx(item: item)) else {
            return Single.error(ItemAPIError.invalidRequest)
        }
        return Single<ItemRx>.create(subscribe: { single in
            var component = URLComponents(url: Url.putItemURL, resolvingAgainstBaseURL: nil != Url.putItemURL.baseURL)
            component?.queryItems = [URLQueryItem(name: "id", value: String(itemId))]
            let url = (component?.url)!
            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = data
            let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
                if let error = error {
                    single(.error(error))
                    return
                }
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    single(.error(ItemAPIError.serverError))
                    return
                }
                guard let data = data else {
                    single(.error(ItemAPIError.jsonParseError))
                    return
                }
                do {
                    let responseData = try JSONDecoder().decode(ItemRx.self, from: data)
                    single(.success(responseData))
                } catch {
                    single(.error(ItemAPIError.jsonParseError))
                }
            })
            task.resume()
            return Disposables.create()
        })
    }

    func deleteItemAPI(itemId: Int) -> Single<DeleteItemResponseRx> {
        var component = URLComponents(url: Url.deleteItemURL, resolvingAgainstBaseURL: nil != Url.putItemURL.baseURL)
        component?.queryItems = [URLQueryItem(name: "id", value: String(itemId))]
        let url = (component?.url)!
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        return Single<DeleteItemResponseRx>.create(subscribe: { single in
            let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
                if let error = error {
                    single(.error(error))
                    return
                }
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    single(.error(ItemAPIError.serverError))
                    return
                }
                guard let data = data else {
                    single(.error(ItemAPIError.jsonParseError))
                    return
                }
                do {
                    let responseData = try JSONDecoder().decode(DeleteItemResponseRx.self, from: data)
                    single(.success(responseData))
                } catch {
                    single(.error(ItemAPIError.jsonParseError))
                }
            })
            task.resume()
            return Disposables.create()
        })
    }
}
