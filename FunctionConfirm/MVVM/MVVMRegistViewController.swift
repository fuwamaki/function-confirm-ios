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

    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var categoryTextField: UITextField!
    @IBOutlet private weak var priceTextField: UITextField!
    @IBOutlet private weak var submitButton: UIButton!

    @IBOutlet private weak var closeNavigationBarButtonItem: UIBarButtonItem!

    private let disposeBag = DisposeBag()

    // Submit完了通知
    var submitCompleted: Observable<Void> {
        return submitCompletedSubject.asObservable()
    }
    private let submitCompletedSubject = PublishSubject<Void>()

    private lazy var viewModel: MVVMRegistViewModel = {
        return MVVMRegistViewModel(viewController: self)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }

    func bind() {
        closeNavigationBarButtonItem.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
}

extension MVVMRegistViewController: StoryboardLoadable {}
