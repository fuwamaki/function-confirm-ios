//
//  QiitaListModel.swift
//  FunctionConfirm
//
//  Created by y-maki on 2018/06/26.
//  Copyright © 2018年 牧宥作. All rights reserved.
//

import Foundation

protocol QiitaListInteractable {
    func getQiitaList()
}

protocol QiitaListDelegate: class {
    func setQiitaList(_ elements: [QiitaListElement])
}

class QiitaListModel: QiitaListInteractable {

    weak var delegate: QiitaListDelegate?

    func getQiitaList() {
        let qiitaListApiRequestService = QiitaListApiRequestService()
        qiitaListApiRequestService.getAPI { [weak self] result in
            switch result {
            case .success(let response):
                self?.delegate?.setQiitaList(response)
            case .failure(let error):
                print(error)
            }
        }
    }
}
