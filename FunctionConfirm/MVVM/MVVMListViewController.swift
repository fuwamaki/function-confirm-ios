//
//  MVVMListViewController.swift
//  FunctionConfirm
//
//  Created by Maki, Yusaku | Mackey | ECID on 2018/12/29.
//  Copyright © 2018年 牧宥作. All rights reserved.
//

import UIKit
import KRProgressHUD
import RxSwift
import RxCocoa

class MVVMListViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.registerForCell(MVVMListTableViewCell.self)
        }
    }
    @IBOutlet private weak var registNavigationBarButtonItem: UIBarButtonItem!

    private let disposeBag = DisposeBag()
    var navigationBarTitle = BehaviorRelay(value: "MVVM List")

    private lazy var viewModel: MVVMListViewModel = {
        return MVVMListViewModel()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        bindNavigationBar()
        bindTableView()
        bindState()
        viewModel.fetchItems().subscribe().disposed(by: disposeBag)
    }

    private func openMVVMSubmitViewController(submitMode: MVVMSubmitViewModel.SubmitMode, item: ItemRx?) {
        let viewController = MVVMSubmitViewController.instantiateFromStoryboard(submitMode: submitMode, item: item)
        viewController.submitCompleted
            .subscribe(onNext: { [weak self] in
                if let weakSelf = self {
                    weakSelf.viewModel.fetchItems().subscribe().disposed(by: weakSelf.disposeBag)
                }
            })
            .disposed(by: disposeBag)
        let navigationController = UINavigationController(rootViewController: viewController)
        present(navigationController, animated: true, completion: nil)
    }

    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "エラー", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    func bindNavigationBar() {
        navigationBarTitle
            .bind(to: navigationItem.rx.title)
            .disposed(by: disposeBag)
        
        registNavigationBarButtonItem.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.openMVVMSubmitViewController(submitMode: .new, item: nil)
            })
            .disposed(by: disposeBag)
    }

    func bindTableView() {
        viewModel.items
            .drive(tableView.rx.items) { tableView, _/*index*/, element in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: MVVMListTableViewCell.defaultReuseIdentifier) as? MVVMListTableViewCell else {
                    fatalError("UITableView.dequeueReusableCell Error")
                }
                cell.render(item: element)
                return cell
            }
            .disposed(by: disposeBag)

        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.openMVVMSubmitViewController(submitMode: .update, item: self?.viewModel.selectedItem(indexPath: indexPath))
                self?.tableView.deselectRow(at: indexPath, animated: false)
            })
            .disposed(by: disposeBag)

        tableView.rx.itemDeleted
            .subscribe(onNext: { [weak self] indexPath in
                if let weakSelf = self {
                    weakSelf.viewModel.deleteItem(selectedIndexPath: indexPath).subscribe().disposed(by: weakSelf.disposeBag)
                }
            })
            .disposed(by: disposeBag)

        tableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
    }

    func bindState() {
        viewModel.stateFetch
            .drive(onNext: { state in
                switch state {
                case .idle:
                    break
                case .itemsFetching:
                    KRProgressHUD.show()
                case .itemsFetchCompleted:
                    KRProgressHUD.dismiss()
                case .errorOccurred(let error):
                    KRProgressHUD.dismiss()
                    self.showErrorAlert(message: error.message)
                }
            })
            .disposed(by: disposeBag)

        viewModel.stateDelete
            .drive(onNext: { state in
                switch state {
                case .idle:
                    break
                case .itemDeleting:
                    break
                case .itemDeleteCompleted:
                    break
                case .errorOccurred(let error):
                    self.showErrorAlert(message: error.message)
                }
            })
            .disposed(by: disposeBag)
    }
}

extension MVVMListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }

    private func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

extension MVVMListViewController: StoryboardLoadable {}
