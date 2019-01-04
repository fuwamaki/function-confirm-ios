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
        return MVVMListViewModel(viewController: self)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        viewModel.fetchItems().subscribe().disposed(by: disposeBag)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchItems().subscribe().disposed(by: disposeBag)
    }

    private func openMVVMRegistViewController() {
        let storyBoard = UIStoryboard(name: "MVVMRegist", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "MVVMRegistViewController")
        let navigationController = UINavigationController(rootViewController: vc)
        present(navigationController, animated: true, completion: nil)
    }

    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "エラー", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    func bind() {
        navigationBarTitle
            .bind(to: navigationItem.rx.title)
            .disposed(by: disposeBag)

        registNavigationBarButtonItem.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.openMVVMRegistViewController()
            })
            .disposed(by: disposeBag)

        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.openMVVMRegistViewController()
                self?.tableView.deselectRow(at: indexPath, animated: false)
            })
            .disposed(by: disposeBag)

        viewModel.state
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

        // TODO: tableviewどうにかする
        viewModel.items
            .drive(tableView.rx.items) { tableView, _/*index*/, element in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: MVVMListTableViewCell.defaultReuseIdentifier) as? MVVMListTableViewCell else {
                    return UITableViewCell()
                }
                cell.render(item: element)
                return cell
            }
            .disposed(by: disposeBag)
    }
}

extension MVVMListViewController: StoryboardLoadable {}
