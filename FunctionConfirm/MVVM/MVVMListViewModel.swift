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
    private let stateFetchSubject = BehaviorRelay<MVVMViewFetchState>(value: .idle)
    var stateFetch: Driver<MVVMViewFetchState> {
        return stateFetchSubject.asDriver(onErrorJustReturn: .idle)
    }
    private let stateDeleteSubject = BehaviorRelay<MVVMViewDeleteState>(value: .idle)
    var stateDelete: Driver<MVVMViewDeleteState> {
        return stateDeleteSubject.asDriver(onErrorJustReturn: .idle)
    }

    private let itemsSubject = BehaviorRelay<[ItemRx]>(value: [])
    var items: Driver<[ItemRx]> {
        return itemsSubject.asDriver(onErrorJustReturn: [])
    }

    func selectedItem(indexPath: IndexPath) -> ItemRx {
        return itemsSubject.value[indexPath.row]
    }

    func fetchItems() -> Completable {
        stateFetchSubject.accept(.itemsFetching)
        return apiRequest.getItemsAPI()
            .do(
                onSuccess: { [weak self] response in
                    self?.itemsSubject.accept([])
                    self?.itemsSubject.accept(response.data)
                    self?.stateFetchSubject.accept(.itemsFetchCompleted)
                    self?.stateFetchSubject.accept(.idle)
                },
                onError: { [weak self] error in
                    print("Error: \(error)")
                    self?.stateFetchSubject.accept(.errorOccurred(.responseFailure))
                    self?.stateFetchSubject.accept(.idle)
                }
            )
            .map { _ in } // Single<Void>に変換
            .asCompletable() // Completableに変換
    }

    func deleteItem(selectedIndexPath: IndexPath) -> Completable {
        stateDeleteSubject.accept(.itemDeleting)
        guard let itemId = selectedItem(indexPath: selectedIndexPath).id else {
            self.stateDeleteSubject.accept(.errorOccurred(.invalidRequest))
            self.stateDeleteSubject.accept(.idle)
            return Completable.empty()
        }
        return apiRequest.deleteItemAPI(itemId: itemId)
            .do(onSuccess: { [weak self] response in
                var items = self?.itemsSubject.value
                items?.remove(at: selectedIndexPath.row)
                self?.itemsSubject.accept(items ?? [])
                self?.stateDeleteSubject.accept(.itemDeleteCompleted)
                self?.stateDeleteSubject.accept(.idle)
                }, onError: { [weak self] error in
                    print("Error: \(error)")
                    self?.stateDeleteSubject.accept(.errorOccurred(.responseFailure))
                    self?.stateDeleteSubject.accept(.idle)
            })
            .map { _ in } // Single<Void>に変換
            .asCompletable() // Completableに変換
    }
}
