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

    var apiRequest = ItemAPIRequestRx()
    private let disposeBag = DisposeBag()

    // BehaviorRelayとDriverはRxcocoa
    private let stateSubject = BehaviorRelay<MVVMViewFetchState>(value: .idle)
    var state: Driver<MVVMViewFetchState> {
        return stateSubject.asDriver(onErrorJustReturn: .idle)
    }

    private let itemsSubject = BehaviorRelay<[ItemRx]>(value: [])
    var items: Driver<[ItemRx]> {
        return itemsSubject.asDriver(onErrorJustReturn: [])
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
