//
//  QiitaListVM.swift
//  FunctionConfirm
//
//  Created by y-maki on 2018/06/26.
//  Copyright © 2018年 牧宥作. All rights reserved.
//

import Foundation

protocol QiitaListEventHandler {
    func getQiitaList()
}

protocol QiitaListUserInterface {
    func setQiitaListElements(_ elements: [QiitaListElement])
}

class QiitaListViewModel: QiitaListEventHandler, QiitaListDelegate {

    var interactable: QiitaListInteractable?
    var userInterface: QiitaListUserInterface?

    func getQiitaList() {
        interactable?.getQiitaList()
    }

    func setQiitaList(_ elements: [QiitaListElement]) {
        userInterface?.setQiitaListElements(elements)
    }
}
