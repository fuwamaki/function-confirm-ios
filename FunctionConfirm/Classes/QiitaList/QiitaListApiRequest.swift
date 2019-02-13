//
//  QiitaListApiRequest.swift
//  FunctionConfirm
//
//  Created by y-maki on 2018/06/26.
//  Copyright © 2018年 牧宥作. All rights reserved.
//

import APIKit
import Result

struct QiitaLists: QiitaListRequest {
    typealias Response = [QiitaListElement]
    let method: HTTPMethod = .get
    let path: String = "/api/v2/items"
    let parameters: Any = ["page": "1", "per_page": "10"]
}

class QiitaListApiRequestService {

    private weak var task: URLSessionDataTask?

    func getAPI(completion: @escaping (Result<QiitaLists.Response, NSError>) -> Void) {
        let request = QiitaLists()
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
