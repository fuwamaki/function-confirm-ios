//
//  MVPPresenter.swift
//  FunctionConfirm
//
//  Created by Maki, Yusaku | Mackey | ECID on 8/8/18.
//  Copyright © 2018 牧宥作. All rights reserved.
//

import Foundation

protocol MVPPresentable: class {
    init(_ view: MVPView)
    var numberOfItems: Int { get }
    func updateItems()
    func deleteItem(_ indexPath: IndexPath)
    func entity(at indexPath: IndexPath) -> Item
}

class MVPPresenter: MVPPresentable {

    private let model: MVPModelInterface
    private var view: MVPView

    var numberOfItems: Int {
        return model.items.count
    }

    required init(_ view: MVPView) {
        self.view = view
        self.model = MVPModel.init(api: RESTfulApiRequest())
        self.model.addObserver(self, selector: #selector(self.updated))
    }

    deinit {
        model.removeObserver(self)
    }

    @objc func updated() {
        view.reloadData()
    }

    func updateItems() {
        model.getItems()
    }

    func deleteItem(_ indexPath: IndexPath) {
        
    }

    func entity(at indexPath: IndexPath) -> Item {
        return model.items[indexPath.row]
    }
}
