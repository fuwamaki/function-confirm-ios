//
//  MVPModel.swift
//  FunctionConfirm
//
//  Created by Maki, Yusaku | Mackey | ECID on 8/8/18.
//  Copyright © 2018 牧宥作. All rights reserved.
//

import Foundation

protocol MVPNotify: class {
    func addObserver(_ observer: Any, selector: Selector)
    func removeObserver(_ observer: Any)
}

protocol MVPModelInterface: MVPNotify {
    var items: [Item] { get }
    func getItems()
}

class MVPModel {

    private(set) var items: [Item] = []
    private let api: RESTfulApiRequest

    required init(api: RESTfulApiRequest) {
        self.api = api
    }
}

extension MVPModel: MVPModelInterface {

    func getItems() {
        api.getAPI { [weak self] result in
            switch result {
            case .success(let response):
                self?.items = response.data
                self?.notify()
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension MVPModel: MVPNotify {
    var notificationName: Notification.Name {
        return Notification.Name(rawValue: "mvpNotify")
    }

    func addObserver(_ observer: Any, selector: Selector) {
        NotificationCenter.default.addObserver(observer, selector: selector, name: notificationName, object: nil)
    }

    func removeObserver(_ observer: Any) {
        NotificationCenter.default.removeObserver(observer)
    }

    func notify() {
        NotificationCenter.default.post(name: notificationName, object: nil)
    }
}
