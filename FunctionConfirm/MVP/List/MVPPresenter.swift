//
//  MVPPresenter.swift
//  FunctionConfirm
//
//  Created by Maki, Yusaku | Mackey | ECID on 8/8/18.
//  Copyright © 2018 牧宥作. All rights reserved.
//

import Foundation

protocol MVPPresentable: class {
    
}

class MVPPresenter {

    var model: MVPModelInterface
    var view: MVPView
    
    init(_ view: MVPView) {
        let model = MVPModel()
        self.view = view
        self.model = model
    }
}

extension MVPPresenter: MVPPresentable {
}
