//
//  MVVMRegistViewController.swift
//  FunctionConfirm
//
//  Created by Maki, Yusaku | Mackey | ECID on 2018/12/30.
//  Copyright © 2018年 牧宥作. All rights reserved.
//

import UIKit
import RxSwift

class MVVMRegistViewController: UIViewController {

    private let disposeBag = DisposeBag()

    private lazy var viewModel: MVVMRegistViewModel = {
        return MVVMRegistViewModel(viewController: self)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
