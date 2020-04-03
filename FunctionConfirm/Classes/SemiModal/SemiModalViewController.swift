//
//  SemiModalViewController.swift
//  FunctionConfirm
//
//  Created by yusaku maki on 2020/04/03.
//  Copyright © 2020 牧宥作. All rights reserved.
//

import UIKit

final class SemiModalViewController: UIViewController {

    @IBAction private func clickShowModalButton(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "SemiModalTest", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "SemiModalTestViewController")
        present(viewController, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

final class ModalPresentationController: UIPresentationController {
    private let overlayView = UIView()

    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()

        overlayView.frame = containerView!.bounds
        overlayView.backgroundColor = .black
        overlayView.alpha = 0.0
        containerView!.insertSubview(overlayView, at: 0)
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [unowned self] _ in
            self.overlayView.alpha = 0.5
        })
    }

    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()

        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [unowned self] _ in
            self.overlayView.alpha = 0.0
        })
    }

    override func dismissalTransitionDidEnd(_ completed: Bool) {
        super.dismissalTransitionDidEnd(completed)

        if completed {
            overlayView.removeFromSuperview()
        }
    }

    override var frameOfPresentedViewInContainerView: CGRect {
        return containerView!.bounds
    }

    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        overlayView.frame = containerView!.bounds
        presentedView!.frame = frameOfPresentedViewInContainerView
    }
}

class DismissAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from) else { return }

        let containerView = transitionContext.containerView

        containerView.addSubview(fromVC.view)

        let screenBounds = UIScreen.main.bounds

        let bottomLeftCorner = CGPoint(x: 0, y: screenBounds.height)
        let finalFrame = CGRect(origin: bottomLeftCorner, size: screenBounds.size)
        let option: UIView.AnimationOptions = transitionContext.isInteractive ? .curveLinear : .curveEaseIn

        UIView.animate(withDuration: transitionDuration(using: transitionContext),
                       delay: 0,
                       options: [option],
                       animations: {
                           fromVC.view.frame = finalFrame
                       },
                       completion: { _ in
                           transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                       }
        )
    }
}

class OverCurrentTransitioningInteractor: UIPercentDrivenInteractiveTransition {
    /// インタラクションの状態
    ///
    /// - none: 開始していない
    /// - shouldStart: 開始できる（開始していない）
    /// - hasStarted: 開始している
    /// - shouldFinish: 終了できる（終了していない）
    enum State {
        case none
        case shouldStart
        case hasStarted
        case shouldFinish
    }

    var state: State = .none

    var startInteractionTranslationY: CGFloat = 0

    var startHandler: (() -> Void)?

    var resetHandler: (() -> Void)?

    /// インタラクションのキャンセル、終了時のAnimation Durationスピードを変更する
    /// デフォルトのままだと、高速に閉じてしまい、瞬間移動しているように見えるため、ここで調整している。
    override func cancel() {
        completionSpeed = percentComplete
        super.cancel()
    }

    override func finish() {
        completionSpeed = 1.0 - percentComplete
        super.finish()
    }

    func setStartInteractionTranslationY(_ translationY: CGFloat) {
        switch state {
        case .shouldStart:
            /// Interaction開始可能な際にInteraction開始までの間更新し続けることで、開始時のYを保持する
            startInteractionTranslationY = translationY
        case .hasStarted, .shouldFinish, .none:
            break
        }
    }

    func updateStateShouldStartIfNeeded() {
        switch state {
        case .none:
            /// .none -> shouldStartへ更新
            state = .shouldStart
            startHandler?()
        case .shouldStart, .hasStarted, .shouldFinish:
            break
        }
    }

    func reset() {
        state = .none
        startInteractionTranslationY = 0
        resetHandler?()
    }
}

protocol OverCurrentTransitionable where Self: UIViewController {
    var percentThreshold: CGFloat { get }
    var interactor: OverCurrentTransitioningInteractor { get }
}

extension OverCurrentTransitionable {
    var shouldFinishVerocityY: CGFloat {
        return 1200
    }
}

extension OverCurrentTransitionable {
    func handleTransitionGesture(_ sender: UIPanGestureRecognizer) {

        ///　TableViewからPanGestureを取得する場合、
        /// dismiss開始をsender.state.beganで判断できないため、Interactor.stateで判定している
        switch interactor.state {
        case .shouldStart:
            interactor.state = .hasStarted
            dismiss(animated: true, completion: nil)
        case .hasStarted, .shouldFinish:
            break
        case .none:
            return
        }

        /// セミモーダルが画面の何割移動したかを計算
        let translation = sender.translation(in: view)
        let verticalMovement = (translation.y - interactor.startInteractionTranslationY) / view.bounds.height
        let downwardMovement = fmaxf(Float(verticalMovement), 0.0)
        let downwardMovementPercent = fminf(downwardMovement, 1.0)
        let progress = CGFloat(downwardMovementPercent)

        /// PanGesture.stateごとに、インタラクションの更新、終了、キャンセルを制御
        switch sender.state {
        case .changed:
            /// スクロール量がしきい値を超えたか？　もしくは　スクロール速度がしきい値を超えたか？
            if progress > percentThreshold || sender.velocity(in: view).y > shouldFinishVerocityY {
                interactor.state =  .shouldFinish
            } else {
                interactor.state =  .hasStarted
            }
            interactor.update(progress)
        case .cancelled:
            interactor.cancel()
            interactor.reset()
        case .ended:
            switch interactor.state {
            case .shouldFinish:
                interactor.finish()
            case .hasStarted, .none, .shouldStart:
                interactor.cancel()
            }
            interactor.reset()
        default:
            break
        }
    }
}
