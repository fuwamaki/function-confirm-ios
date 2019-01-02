//
//  MVVMListViewModel.swift
//  FunctionConfirm
//
//  Created by Maki, Yusaku | Mackey | ECID on 2018/12/30.
//  Copyright © 2018年 牧宥作. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class MVVMListViewModel {

    private let viewController: UIViewController
    private var apiRequest: ItemAPIRequestRxProtocol
    private let disposeBag = DisposeBag()

//    private lazy var registViewController: MVVMRegistViewController = {
//        let viewController = MVVMRegistViewController.
//    }

    // for viewController
    convenience init(viewController: UIViewController) {
        self.init(viewController: viewController, request: ItemAPIRequestRx())
    }

    // for test
    init(viewController: UIViewController, request: ItemAPIRequestRxProtocol) {
        self.viewController = viewController
        self.apiRequest = request
    }

    func showRegistViewController() {
        
    }
}
