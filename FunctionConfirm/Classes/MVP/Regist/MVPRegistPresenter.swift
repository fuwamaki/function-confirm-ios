//
//  MVPRegistPresenter.swift
//  FunctionConfirm
//
//  Created by Maki, Yusaku | Mackey | ECID on 8/8/18.
//  Copyright © 2018 牧宥作. All rights reserved.
//

import Foundation

protocol MVPRegistPresentable: class {
    init(_ view: MVPRegistView)
    func registerItem(_ item: Item)
}

class MVPRegistPresenter: MVPRegistPresentable {

    private let model: MVPRegistModel
    private var view: MVPRegistView

    required init(_ view: MVPRegistView) {
        self.view = view
        self.model = MVPRegistModel.init(api: RESTfulApiRequest())
        self.model.addObserver(self, selector: #selector(self.close))
    }

    func registerItem(_ item: Item) {
        model.postItem(item)
    }

    @objc func close() {
        view.close()
    }
}
