//
//  MVVMListViewModelText.swift
//  FunctionConfirmTests
//
//  Created by Maki, Yusaku | Mackey | ECID on 2019/01/06.
//  Copyright © 2019年 牧宥作. All rights reserved.
//

import XCTest
@testable import FunctionConfirm
import RxSwift
import RxCocoa
import RxTest
import RxBlocking

class MVVMListViewModelText: XCTestCase {

    func testStateFetch() {
        let scheduler = TestScheduler(initialClock: 0)
        let viewModel = MVVMListViewModel()
        viewModel.apiRequest = MockItemAPIRequestRx()
        let disposeBag = DisposeBag()
        let results = scheduler.createObserver(MVVMViewFetchState.self)

        scheduler.scheduleAt(100) {
            viewModel.stateFetch
                .drive(results)
                .disposed(by: disposeBag)
        }

        scheduler.scheduleAt(200) {
            _ = try? viewModel.fetchItems().toBlocking().single()
        }

        scheduler.start()

        let expectedEvents = Recorded.events(
            .next(100, MVVMViewFetchState.idle),
            .next(200, MVVMViewFetchState.itemsFetching),
            .next(200, MVVMViewFetchState.itemsFetchCompleted),
            .next(200, MVVMViewFetchState.idle)
        )
        XCTAssertEqual(results.events, expectedEvents)
    }

    func testItems() {
        let scheduler = TestScheduler(initialClock: 0)
        let viewModel = MVVMListViewModel()
        viewModel.apiRequest = MockItemAPIRequestRx()
        let disposeBag = DisposeBag()

        let results = scheduler.createObserver(Int.self)

        scheduler.scheduleAt(100) {
            viewModel.items
                .map { $0.count }
                .drive(results)
                .disposed(by: disposeBag)
        }

        scheduler.scheduleAt(200) {
            _ = try? viewModel.fetchItems().toBlocking().single()
        }

        scheduler.start()
        let expectedEvents = Recorded.events(
            .next(100, 0),
            .next(200, 0),
            .next(200, 3)
        )

        XCTAssertEqual(results.events, expectedEvents)
    }
}

extension MVVMListViewModelText {
    class MockItemAPIRequestRx: ItemAPIRequestRx {
        override func getItemsAPI() -> Single<GetItemResponseRx> {
            let testData = GetItemResponseRx(status: 0, data: [
                ItemRx(id: 1, name: "Apple", category: "Fruit", price: 100),
                ItemRx(id: 2, name: "Orange", category: "Fruit", price: 200),
                ItemRx(id: 3, name: "Banana", category: "Fruit", price: 300)
                ])
            return Observable.of(testData).asSingle()
        }
    }
}
