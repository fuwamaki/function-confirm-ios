//
//  Store.swift
//  FunctionConfirm
//
//  Created by Maki, Yusaku | Mackey | ECID on 2019/04/28.
//  Copyright © 2019年 牧宥作. All rights reserved.
//

import ReSwift

// The global application store, which is responsible for managing the appliction state.
let mainStore = Store<AppState>(
    reducer: counterReducer,
    state: nil
)
