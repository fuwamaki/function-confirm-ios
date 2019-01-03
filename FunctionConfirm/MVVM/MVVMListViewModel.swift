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
import RxCocoa

class MVVMListViewModel {

    enum ViewState: Equatable {
        case idle
        case itemsFetching
        case itemsFetchCompleted
        case errorOccurred(ItemAPIRequestError)

        static func == (lhs: ViewState, rhs: ViewState) -> Bool {
            switch (lhs, rhs) {
            case (.idle, .idle):
                return true
            case (.itemsFetching, .itemsFetching):
                return true
            case (.itemsFetchCompleted, .itemsFetchCompleted):
                return true
            case (.errorOccurred, .errorOccurred):
                return true
            default:
                return false
            }
        }
    }

    private let viewController: UIViewController
    private var apiRequest: ItemAPIRequestRxProtocol
    private let disposeBag = DisposeBag()

    // BehaviorRelayとDriverはRxcocoa
    private let stateSubject = BehaviorRelay<ViewState>(value: .idle)
    var state: Driver<ViewState> {
        return stateSubject.asDriver(onErrorJustReturn: .idle)
    }

    private let itemsSubject = BehaviorRelay<[ItemRx]>(value: [])
    var items: Driver<[ItemRx]> {
        return itemsSubject.asDriver(onErrorJustReturn: [])
    }

    private lazy var registViewController: MVVMRegistViewController = {
        let viewController = MVVMRegistViewController.instantiateFromStoryboardByFileName()
        viewController.submitCompleted
            .subscribe(onNext: { [weak self] in
                if let weakSelf = self {
                    weakSelf.fetchItems().subscribe().disposed(by: weakSelf.disposeBag)
                }
            })
            .disposed(by: disposeBag)
        return viewController
    }()

    // for viewController
    convenience init(viewController: UIViewController) {
        self.init(viewController: viewController, request: ItemAPIRequestRx())
    }

    // for test
    init(viewController: UIViewController, request: ItemAPIRequestRxProtocol) {
        self.viewController = viewController
        self.apiRequest = request
    }


    func fetchItems() -> Completable {
        stateSubject.accept(.itemsFetching)
        return apiRequest.getItems()
        .do(
            onSuccess: { [weak self] response in
                self?.itemsSubject.accept([])
                self?.itemsSubject.accept(response.data)
                self?.stateSubject.accept(.itemsFetchCompleted)
                self?.stateSubject.accept(.idle)
            },
            onError: { [weak self] error in
                print("Error: \(error)")
                self?.stateSubject.accept(.errorOccurred(.responseFailure))
                self?.stateSubject.accept(.idle)
            }
        )
            .map { _ in } // Single<Void>に変換
        .asCompletable() // Completableに変換
    }
}
