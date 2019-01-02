//
//  MVVMRegistViewModel.swift
//  FunctionConfirm
//
//  Created by Maki, Yusaku | Mackey | ECID on 2018/12/30.
//  Copyright © 2018年 牧宥作. All rights reserved.
//

import UIKit
import RxSwift

class MVVMRegistViewModel {

    private let viewController: UIViewController
    private let apiRequest: ItemAPIRequestRxProtocol
    private let disponseBag = DisposeBag()

    // for viewController
    convenience init(viewController: UIViewController) {
        self.init(viewController: viewController, request: ItemAPIRequestRx())
    }

    // for test
    init(viewController: UIViewController, request: ItemAPIRequestRxProtocol) {
        self.viewController = viewController
        self.apiRequest = request
    }
}
