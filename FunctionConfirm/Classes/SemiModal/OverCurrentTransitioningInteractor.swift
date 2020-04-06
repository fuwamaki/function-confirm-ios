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

    public func reset() {
        state = .none
        startInteractionTranslationY = 0
        resetHandler?()
    }
}
