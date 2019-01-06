//
//  MVVMViewState.swift
//  FunctionConfirm
//
//  Created by Maki, Yusaku | Mackey | ECID on 2019/01/04.
//  Copyright © 2019年 牧宥作. All rights reserved.
//

import Foundation

enum MVVMViewFetchState: Equatable {
    case idle
    case itemsFetching
    case itemsFetchCompleted
    case errorOccurred(ItemAPIRequestError)
    
    static func == (lhs: MVVMViewFetchState, rhs: MVVMViewFetchState) -> Bool {
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

enum MVVMViewSubmitState: Equatable {
    case idle
    case itemSubmitting
    case itemSubmitCompleted
    case errorOccurred(ItemAPIRequestError)

    static func == (lhs: MVVMViewSubmitState, rhs: MVVMViewSubmitState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle):
            return true
        case (.itemSubmitting, .itemSubmitting):
            return true
        case (.itemSubmitCompleted, .itemSubmitCompleted):
            return true
        case (.errorOccurred, .errorOccurred):
            return true
        default:
            return false
        }
    }
}

enum MVVMViewDeleteState: Equatable {
    case idle
    case itemDeleting
    case itemDeleteCompleted
    case errorOccurred(ItemAPIRequestError)

    static func == (lhs: MVVMViewDeleteState, rhs: MVVMViewDeleteState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle):
            return true
        case (.itemDeleting, .itemDeleting):
            return true
        case (.itemDeleteCompleted, .itemDeleteCompleted):
            return true
        case (.errorOccurred, .errorOccurred):
            return true
        default:
            return false
        }
    }
}
