//
//  MVVMSubmitViewModel.swift
//  FunctionConfirm
//
//  Created by Maki, Yusaku | Mackey | ECID on 2018/12/30.
//  Copyright © 2018年 牧宥作. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

// TODO: RegistじゃなくてSubmitにする
class MVVMSubmitViewModel {

    enum SubmitMode {
        case new
        case update
    }

    // viewController消す
    var apiRequest = ItemAPIRequestRx()
    private let disposeBag = DisposeBag()

    var navigationBarTitle = BehaviorRelay(value: "Regist")
    var itemId = BehaviorRelay<Int?>(value: nil)
    var nameText = BehaviorRelay<String?>(value: nil)
    var categoryText = BehaviorRelay<String?>(value: nil)
    var priceText = BehaviorRelay<String?>(value: nil)
    var submitMode = BehaviorRelay<SubmitMode>(value: .new)
    var submitItem = BehaviorRelay<ItemRx?>(value: nil)

    lazy var nameValid: Observable<Bool> = {
        return nameText
            .map { ($0 ?? "").count > 0 }
            .share(replay: 1)
    }()

    lazy var categoryValid: Observable<Bool> = {
        return categoryText
            .map{ ($0 ?? "").count > 0}
            .share(replay: 1)
    }()

    lazy var priceValid: Observable<Bool> = {
        return priceText
            .map{ ($0 ?? "").count > 0}
            .share(replay: 1)
    }()

    lazy var allFieldsValid: Observable<Bool> = {
        return Observable
            .combineLatest(nameValid, categoryValid, priceValid) { $0 && $1 && $2 }
            .share(replay: 1)
    }()

    private let stateSubject = BehaviorRelay<MVVMViewSubmitState>(value: .idle)
    var state: Driver<MVVMViewSubmitState> {
        return stateSubject.asDriver(onErrorJustReturn: .idle)
    }
    let dismissSubject = BehaviorRelay<Bool>(value: false)

    init() {
        bindSubmitItem()
    }

    // view側に影響ないものはViewModel側でbindする
    private func bindSubmitItem() {
        submitItem
            .flatMap { $0.flatMap{ Observable.just($0) } ?? Observable.empty() }
            .subscribe(onNext: { [weak self] item in
                self?.itemId.accept(item.id)
                self?.nameText.accept(item.name)
                self?.categoryText.accept(item.category)
                self?.priceText.accept(String(item.price))
            })
            .disposed(by: disposeBag)

        submitItem
            .filter { $0 == nil }
            .subscribe(onNext: { [weak self] _ in
                self?.nameText.accept(nil)
                self?.categoryText.accept(nil)
                self?.priceText.accept(nil)
            })
            .disposed(by: disposeBag)
    }

    func postItem() -> Completable {
        stateSubject.accept(.itemSubmitting)
        guard let name = nameText.value, let category = categoryText.value,
            let priceStr = priceText.value, let price = Int(priceStr) else {
                self.stateSubject.accept(.errorOccurred(.invalidRequest))
                self.stateSubject.accept(.idle)
                return Completable.empty()
        }
        let item = ItemRx(id: nil, name: name, category: category, price: price)
        return apiRequest.postItemAPI(item: item)
            .do(
                onSuccess: { [weak self] _ in
                    self?.stateSubject.accept(.itemSubmitCompleted)
                    self?.stateSubject.accept(.idle)
                    self?.dismissSubject.accept(true)
                },
                onError: { [weak self] error in
                    print("Error: \(error)")
                    self?.stateSubject.accept(.errorOccurred(.responseFailure))
                    self?.stateSubject.accept(.idle)
                }
            )
            .map { _ in }
            .asCompletable()
    }

    func putItem() -> Completable {
        stateSubject.accept(.itemSubmitting)
        guard let itemId = itemId.value, let name = nameText.value, let category = categoryText.value,
            let priceStr = priceText.value, let price = Int(priceStr) else {
                self.stateSubject.accept(.errorOccurred(.invalidRequest))
                self.stateSubject.accept(.idle)
                return Completable.empty()
        }
        let item = ItemRx(id: nil, name: name, category: category, price: price)
        return apiRequest.putItemAPI(itemId: itemId, item: item)
            .do(
                onSuccess: { [weak self] _ in
                    self?.stateSubject.accept(.itemSubmitCompleted)
                    self?.stateSubject.accept(.idle)
                    self?.dismissSubject.accept(true)
                },
                onError: { [weak self] error in
                    print("Error: \(error)")
                    self?.stateSubject.accept(.errorOccurred(.responseFailure))
                    self?.stateSubject.accept(.idle)
                }
            )
            .map { _ in }
            .asCompletable()
    }
}
