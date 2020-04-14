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
    private var displayState: DisplayState = .half

    public var startHandler: (() -> Void)?
    public var dismissHandler: (() -> Void)?
    public var allStateHandler: (() -> Void)?
    public var halfStateHandler: (() -> Void)?
    public var layoutIfNeededHandler: (() -> Void)?

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
        completionSpeed = 0.1
        super.cancel()
    }

    /// interactionの終了時のAnimation Durationスピードを変更。defaultだと高速に閉じてしまうので、スピードを調整。
    override func finish() {
        completionSpeed = 1.0 - percentComplete
        super.finish()
    }

    // swiftlint:disable function_body_length
    // swiftlint:disable cyclomatic_complexity
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
        case (.all, let ratio) where 0.2 < ratio && ratio <= 0.7:
            swipeState = .canBeHalf
        case (.half, let ratio) where ratio < 0.5:
            swipeState = .canBeAll
        case (.half, let ratio) where 0.5 <= ratio && ratio <= 0.7:
            swipeState = .swiping
        case (_, let ratio) where 0.7 < ratio:
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
            update(movedRatio)
            UIView.animateKeyframes(withDuration: 0.5, delay: 0.0, options: [.overrideInheritedDuration], animations: {
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.1, animations: {
                    self.layoutIfNeededHandler?()
                })
                UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.01, animations: {
                    self.cancel()
                })
            }, completion: nil)
        default:
            break
        }
    }
}
