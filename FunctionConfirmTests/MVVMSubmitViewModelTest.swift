//
//  MVVMSubmitViewModelTest.swift
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

class MVVMSubmitViewModelTest: XCTestCase {

    func testNameValid() {
        let scheduler = TestScheduler(initialClock: 0)
        let viewModel = MVVMSubmitViewModel()
        let disposeBag = DisposeBag()

        let nameSchedule = scheduler.createHotObservable([
            .next(100, ""),
            .next(200, "Banana"),
            .next(300, "")
            ])

        nameSchedule
            .bind(to: viewModel.nameText)
            .disposed(by: disposeBag)

        let observer = scheduler.createObserver(Bool.self)
        viewModel.nameValid
            .subscribe(observer)
            .disposed(by: disposeBag)

        scheduler.start()

        let expectedEvents = Recorded.events(
            .next(0, false),
            .next(100, false),
            .next(200, true),
            .next(300, false)
        )

        XCTAssertEqual(observer.events, expectedEvents)
    }

    func testCategoryValid() {
        let scheduler = TestScheduler(initialClock: 0)
        let viewModel = MVVMSubmitViewModel()
        let disposeBag = DisposeBag()

        let categorySchedule = scheduler.createHotObservable([
            .next(100, ""),
            .next(200, "Fruit"),
            .next(300, "")
            ])
        categorySchedule
        .bind(to: viewModel.categoryText)
        .disposed(by: disposeBag)

        let results = scheduler.createObserver(Bool.self)
        viewModel.categoryValid
            .subscribe(results)
            .disposed(by: disposeBag)

        scheduler.start()

        let expectedEvents = Recorded.events(
            .next(0, false),
            .next(100, false),
            .next(200, true),
            .next(300, false)
        )

        XCTAssertEqual(results.events, expectedEvents)
    }

    func testPriceValid() {
        let scheduler = TestScheduler(initialClock: 0)
        let viewModel = MVVMSubmitViewModel()
        let disposeBag = DisposeBag()

        let priceSchedule = scheduler.createHotObservable([
            .next(100, ""),
            .next(200, "1000"),
            .next(300, "")
            ])
        priceSchedule
        .bind(to: viewModel.priceText)
        .disposed(by: disposeBag)

        let results = scheduler.createObserver(Bool.self)
        viewModel.priceValid
        .subscribe(results)
        .disposed(by: disposeBag)

        scheduler.start()

        let expectedEvents = Recorded.events(
            .next(0, false),
            .next(100, false),
            .next(200, true),
            .next(300, false)
        )

        XCTAssertEqual(results.events, expectedEvents)
    }

    func testState() {
        let scheduler = TestScheduler(initialClock: 0)
        let viewModel = MVVMSubmitViewModel()
        let disposeBag = DisposeBag()

        let results = scheduler.createObserver(MVVMViewSubmitState.self)

        scheduler.scheduleAt(100) {
            viewModel.state
            .drive(results)
            .disposed(by: disposeBag)
        }

        scheduler.createHotObservable([
            .next(100, "Banana")
            ])
        .bind(to: viewModel.nameText)
        .disposed(by: disposeBag)

        scheduler.createHotObservable([
            .next(200, "fruit")
            ])
        .bind(to: viewModel.categoryText)
        .disposed(by: disposeBag)

        scheduler.createHotObservable([
            .next(300, "1000")
            ])
        .bind(to: viewModel.priceText)
        .disposed(by: disposeBag)

        scheduler.scheduleAt(400) {
            _ = try? viewModel.postItem().toBlocking().single()
        }

        scheduler.start()

        let expectedEvents: [Recorded<Event<MVVMViewSubmitState>>] = Recorded.events(
            .next(100, MVVMViewSubmitState.idle),
            .next(400, MVVMViewSubmitState.itemSubmitting),
            .next(400, MVVMViewSubmitState.itemSubmitCompleted),
            .next(400, MVVMViewSubmitState.idle)
        )

        XCTAssertEqual(results.events, expectedEvents)
    }
}

extension MVVMSubmitViewModelTest {
    class MockItemAPIRequestRx: ItemAPIRequestRx {

        override func postItemAPI(item: ItemRx) -> Single<ItemRx> {
            let testData = ItemRx(id: 10, name: "Apple", category: "Fruit", price: 100)
            return Observable.of(testData).asSingle()
        }
    }
}
