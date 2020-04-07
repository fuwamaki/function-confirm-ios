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

    enum State {
        case none // 開始していない
        case shouldStart // 開始できる（開始していない）
        case hasStarted // 開始している
        case shouldFinish // 終了できる（終了していない）
    }

    private var swipeState: SwipeState = .normal
    private var displayState: DisplayState = .half

    private var state: State = .none
    private var startInteractionTranslationY: CGFloat = 0

    public var startHandler: (() -> Void)?
    public var resetHandler: (() -> Void)?
    public var dismissHandler: (() -> Void)?

    // modal表示するviewのy座標。half表示時またはall表示時の値のみが入る
    public var viewOriginY: CGFloat = 0
    public var isUseInteractor: Bool {
        /// インタラクション開始している場合だけinteractorを返す
        switch state {
        case .hasStarted, .shouldFinish:
            return true
        default:
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

    private func reset() {
//        state = .none
        startInteractionTranslationY = 0
        resetHandler?()
    }

    public func setStartInteractionTranslationY(_ translationY: CGFloat) {
        switch state {
        case .shouldStart:
            /// Interaction開始直後のy座標を保持する
            startInteractionTranslationY = translationY
        default:
            break
        }
    }

    public func updateStateShouldStartIfNeeded() {
        switch state {
        case .none:
            state = .shouldStart
            startHandler?()
        default:
            break
        }
    }

    public func handleTransitionGesture(view: UIView, sender: UIPanGestureRecognizer) {
        ///　dismiss開始の判定はstateが.shouldStartかどうかで判定(sender.state.beganで判断できないため)
        switch state {
        case .shouldStart:
            state = .hasStarted
            dismissHandler?()
        case .hasStarted, .shouldFinish:
            break
        case .none:
            return
        }

        let translation = sender.translation(in: view)
        let verticalMovement = (translation.y - startInteractionTranslationY) / view.bounds.height

        // swipeで更新されたoriginYの値
        let updatedviewOriginY = viewOriginY + (translation.y - startInteractionTranslationY)
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

        /// SemiModalViewが画面の何割移動したか
        let movementRatio = CGFloat(fminf(fmaxf(Float(verticalMovement), 0.0), 1.0))
        /// スクロール量が閾値を超えたか、又はスクロール速度が閾値を超えたか
        let isShouldFinish = movementRatio > 0.3 || sender.velocity(in: view).y > 1200

        switch (sender.state, isShouldFinish, state) {
        case (.changed, true, _):
            state = .shouldFinish
            update(verticalMovement)
        case (.changed, false, _):
            state = .hasStarted
            update(verticalMovement)
        case (.cancelled, _, _):
            cancel()
            reset()
        case (.ended, _, .shouldFinish):
            finish()
            reset()
        case (.ended, _, _):
//            cancel()
            state = .shouldStart
            reset()
            cancel()
        default:
            break
        }
    }
}
