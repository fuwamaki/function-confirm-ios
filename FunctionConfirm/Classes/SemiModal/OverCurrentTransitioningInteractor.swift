//
//  OverCurrentTransitioningInteractor.swift
//  FunctionConfirm
//
//  Created by yusaku maki on 2020/04/06.
//  Copyright © 2020 牧宥作. All rights reserved.
//

import UIKit

private enum SwipeState {
    case normal
    case startMoving
    case swiping
    case canBeAll
    case canBeHalf
    case canDismiss
}

private enum DisplayState {
    case half
    case all
}

class OverCurrentTransitioningInteractor: UIPercentDrivenInteractiveTransition {

    private var swipeState: SwipeState = .normal
    private var displayState: DisplayState = .all

    public var startHandler: (() -> Void)?
    public var dismissHandler: (() -> Void)?
    public var allStateHandler: (() -> Void)?
    public var halfStateHandler: (() -> Void)?

    // modal表示するviewのy座標。half表示時またはall表示時の値のみが入る
    public var viewOriginY: CGFloat = 0

    public var isUseInteractor: Bool {
        /// インタラクション開始している場合だけinteractorを返す
        switch swipeState {
        case .swiping, .canBeAll, .canBeHalf, .canDismiss:
            return true
        case .normal, .startMoving:
            return false
        }
    }

    /// interactionのキャンセル時のAnimation Durationスピードを変更。defaultだと高速に閉じてしまうので、スピードを調整。
    override func cancel() {
        completionSpeed = percentComplete
        super.cancel()
    }

    /// interactionの終了時のAnimation Durationスピードを変更。defaultだと高速に閉じてしまうので、スピードを調整。
    override func finish() {
        completionSpeed = 1.0 - percentComplete
        super.finish()
    }

    public func handleSwipeGesture(view: UIView, sender: UIPanGestureRecognizer) {
        guard swipeState != .normal else {
            swipeState = .startMoving
            startHandler?()
            return
        }
        guard swipeState != .startMoving else {
            /// dismissを開始で、Viewを動かせるようになる
            swipeState = .swiping
            dismissHandler?()
            return
        }
        // swipeで更新されたoriginYの値
        let updatedviewOriginY = viewOriginY + sender.translation(in: view).y
        let updatedviewRatio = updatedviewOriginY / view.bounds.height
        switch (displayState, updatedviewRatio) {
        case (.all, let ratio) where ratio <= 0.2:
            swipeState = .swiping
        case (.all, let ratio) where 0.2 < ratio:
            swipeState = .canBeHalf
        case (.half, let ratio) where ratio < 0.5:
            swipeState = .canBeAll
        case (.half, let ratio) where 0.5 <= ratio && ratio <= 0.7:
            swipeState = .swiping
        case (.half, let ratio) where 0.7 < ratio:
            swipeState = .canDismiss
        default:
            break
        }
        let movedRatio = sender.translation(in: view).y / view.bounds.height
        switch (sender.state, swipeState, displayState) {
        case (.changed, _, _):
            update(movedRatio)
        case (.ended, .canDismiss, _):
            finish()
        case (.ended, .canBeAll, _), (.ended, .swiping, .all), (.cancelled, .canBeAll, _), (.cancelled, .swiping, .all):
            allStateHandler?()
            swipeState = .normal
            displayState = .all
            cancel()
        case (.ended, .canBeHalf, _), (.ended, .swiping, .half), (.cancelled, .canBeHalf, _), (.cancelled, .swiping, .half):
            halfStateHandler?()
            swipeState = .normal
            displayState = .half
            cancel()
        default:
            break
        }
    }
}
