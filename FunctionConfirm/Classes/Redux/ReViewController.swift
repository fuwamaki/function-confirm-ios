//
//  ReViewController.swift
//  FunctionConfirm
//
//  Created by Maki, Yusaku | Mackey | ECID on 2019/04/27.
//  Copyright © 2019年 牧宥作. All rights reserved.
//

import UIKit
import ReSwift

final class ReViewController: UIViewController {

    @IBOutlet weak var label: UILabel!

    @IBAction func clickUpButton(_ sender: Any) {
        mainStore.dispatch(CounterActionIncrease())
    }

    @IBAction func clickDownButton(_ sender: Any) {
        mainStore.dispatch(CounterActionDecrease())
    }

    typealias StoreSubscriberStateType = AppState

    override func viewDidLoad() {
        super.viewDidLoad()
        // subscribe to state changes
        mainStore.subscribe(self)
    }

    func newState(state: AppState) {
        // when the state changes, the UI is updated to reflect the current state
        label.text = "\(mainStore.state.counter)"
    }
}

extension ReViewController: StoreSubscriber {}
