//
//  MVVMRegistViewController.swift
//  FunctionConfirm
//
//  Created by Maki, Yusaku | Mackey | ECID on 2018/12/30.
//  Copyright © 2018年 牧宥作. All rights reserved.
//

import UIKit
import RxSwift
import KRProgressHUD

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
        bindNavigationBar()
        bindDismiss()
        bindSubmitItem()
        bindTextFields()
        bindButton()
        bindState()
    }

    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "エラー", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    private func bindDismiss() {
        viewModel.dismissSubject
            .subscribe(onNext: { [weak self] isDismiss in
                if isDismiss {
                    self?.dismiss(animated: true, completion: nil)
                }
            })
        .disposed(by: disposeBag)
    }

    private func bindNavigationBar() {
        viewModel.navigationBarTitle
            .bind(to: navigationItem.rx.title)
            .disposed(by: disposeBag)

        closeNavigationBarButtonItem.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }

    private func bindSubmitItem() {
        viewModel.submitItem
            .flatMap { $0.flatMap{ Observable.just($0) } ?? Observable.empty() }
            .subscribe(onNext: { [weak self] item in
                self?.viewModel.itemId.accept(item.id)
                self?.viewModel.nameText.accept(item.name)
                self?.viewModel.categoryText.accept(item.category)
                self?.viewModel.priceText.accept(String(item.price))
            })
            .disposed(by: disposeBag)

        viewModel.submitItem
            .filter { $0 == nil }
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.nameText.accept(nil)
                self?.viewModel.categoryText.accept(nil)
                self?.viewModel.priceText.accept(nil)
            })
            .disposed(by: disposeBag)
    }

    private func bindTextFields() {
        viewModel.nameText
            .asDriver(onErrorJustReturn: "")
            .drive(nameTextField.rx.text)
            .disposed(by: disposeBag)

        nameTextField.rx.text.orEmpty
            .bind(to: viewModel.nameText)
            .disposed(by: disposeBag)

        viewModel.categoryText
            .asDriver(onErrorJustReturn: "")
            .drive(categoryTextField.rx.text)
            .disposed(by: disposeBag)

        categoryTextField.rx.text.orEmpty
            .bind(to: viewModel.categoryText)
            .disposed(by: disposeBag)

        viewModel.priceText
            .asDriver(onErrorJustReturn: "")
            .drive(priceTextField.rx.text)
            .disposed(by: disposeBag)

        priceTextField.rx.text.orEmpty
            .bind(to: viewModel.priceText)
            .disposed(by: disposeBag)
    }

    private func bindButton() {
        viewModel.allFieldsValid
            .bind(to: submitButton.rx.isEnabled)
            .disposed(by: disposeBag)

        submitButton.rx.tap
            .subscribe(onNext: { [weak self] in
                if let weakSelf = self {
                    weakSelf.viewModel.postItem().subscribe().disposed(by: weakSelf.disposeBag)
                }
            })
            .disposed(by: disposeBag)
    }

    private func bindState() {
        viewModel.state
            .drive(onNext: { [weak self] state in
                switch state {
                case .idle:
                    break
                case .itemSubmitting:
                    KRProgressHUD.show()
                case .itemSubmitCompleted:
                    KRProgressHUD.dismiss()
                    self?.submitCompletedSubject.onNext(())
                case .errorOccurred(let error):
                    KRProgressHUD.dismiss()
                    self?.showErrorAlert(message: error.message)
                }
            })
            .disposed(by: disposeBag)
    }
}

extension MVVMRegistViewController: StoryboardLoadable {}
