//
//  OverCurrentTransitioningInteractor.swift
//  FunctionConfirm
//
//  Created by yusaku maki on 2020/04/06.
//  Copyright © 2020 牧宥作. All rights reserved.
//

import UIKit

class OverCurrentTransitioningInteractor: UIPercentDrivenInteractiveTransition {

    enum State {
        case none // 開始していない
        case shouldStart // 開始できる（開始していない）
        case hasStarted // 開始している
        case shouldFinish // 終了できる（終了していない）
    }

    public var state: State = .none
    public var startInteractionTranslationY: CGFloat = 0
    public var startHandler: (() -> Void)?
    public var resetHandler: (() -> Void)?
    public var dismissHandler: (() -> Void)?

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
        state = .none
        startInteractionTranslationY = 0
        resetHandler?()
    }

    public func setStartInteractionTranslationY(_ translationY: CGFloat) {
        switch state {
        case .shouldStart:
            /// Interaction開始可能な際にInteraction開始までの間更新し続けることで、開始時のYを保持する
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
        let verticalMovement = (translation.y - startInteractionTranslationY)/view.bounds.height
        /// SemiModalViewが画面の何割移動したか
        let movementRatio = CGFloat(fminf(fmaxf(Float(verticalMovement), 0.0), 1.0))
        /// スクロール量が閾値を超えたか、又はスクロール速度が閾値を超えたか
        let isShouldFinish = movementRatio > 0.3 || sender.velocity(in: view).y > 1200

        switch (sender.state, isShouldFinish, state) {
        case (.changed, true, _):
            state = .shouldFinish
            update(movementRatio)
        case (.changed, false, _):
            state = .hasStarted
            update(movementRatio)
        case (.cancelled, _, _):
            cancel()
            reset()
        case (.ended, _, .shouldFinish):
            finish()
            reset()
        case (.ended, _, _):
            cancel()
            reset()
        default:
            break
        }
    }
}
