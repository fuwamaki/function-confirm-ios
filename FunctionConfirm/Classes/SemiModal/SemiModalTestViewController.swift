//
//  SemiModalTestViewController.swift
//  FunctionConfirm
//
//  Created by yusaku maki on 2020/04/03.
//  Copyright © 2020 牧宥作. All rights reserved.
//

import UIKit

final class SemiModalTestViewController: UIViewController, OverCurrentTransitionable {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.registerForCell(SemiModalTestTableCell.self)
        }
    }

    var interactor = OverCurrentTransitioningInteractor()

    private var tableViewContentOffsetY: CGFloat = 0.0

    var array: [String] = ["1", "2", "3"]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    private func setupViews() {
        tableView.tableFooterView = UIView()
        transitioningDelegate = self
        interactor.startHandler = { [weak self] in
            // bounces: ScrollViewがコンテンツの端を越えて跳ね返る(bounce)か、また戻るか
            self?.tableView.bounces = false
        }
        interactor.resetHandler = { [weak self] in
            self?.tableView.bounces = true
        }

        headerView.layer.cornerRadius = 8.0
        headerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        let headerGesture = UIPanGestureRecognizer(target: self, action: #selector(headerDidScroll(_:)))
        headerView.addGestureRecognizer(headerGesture)
        // handle tap backgroundView
        let gesture = UITapGestureRecognizer(target: self, action: #selector(backgroundDidTap))
        backgroundView.addGestureRecognizer(gesture)
        // handle swipe tableView
        let tableViewGesture = UIPanGestureRecognizer(target: self, action: #selector(handleTableViewSwipe(_:)))
        tableViewGesture.delegate = self
        tableView.addGestureRecognizer(tableViewGesture)
    }

    @objc private func headerDidScroll(_ sender: UIPanGestureRecognizer) {
        /// ヘッダービューをスワイプした場合の処理
        /// コールされたと同時にインタラクション開始する。
        interactor.updateStateShouldStartIfNeeded()
        handleTransitionGesture(sender)
    }

    @objc private func backgroundDidTap() {
        dismiss(animated: true, completion: nil)
    }

    /// TableViewをSwipeした場合の処理
    @objc private func handleTableViewSwipe(_ sender: UIPanGestureRecognizer) {
        /// TableViewのScrollがTop位置の場合、interactorの状態を更新
        if tableViewContentOffsetY <= 0 {
            interactor.updateStateShouldStartIfNeeded()
        }
        /// インタラクション開始位置と、テーブルビュースクロール開始位置が異なるため、インタラクション開始時のY位置を取得している
        interactor.setStartInteractionTranslationY(sender.translation(in: view).y)
        handleTransitionGesture(sender)
    }
}

// MARK: UITableViewDelegate
extension SemiModalTestViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        tableViewContentOffsetY = scrollView.contentOffset.y
    }
}

// MARK: UITableViewDataSource
extension SemiModalTestViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCellForIndexPath(indexPath) as SemiModalTestTableCell
        cell.render(text: array[indexPath.row])
        return cell
    }
}

// MARK: UIGestureRecognizerDelegate
extension SemiModalTestViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

// MARK: UIViewControllerTransitioningDelegate
/// 以下デリゲートメソッドで、セミモーダルの閉じる処理に関する設定している
extension SemiModalTestViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        ///　セミモーダル遷移時の背景透過アニメーションを行うPresentationControllerを返却
        return ModalPresentationController(presentedViewController: presented, presenting: presenting)
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        /// dismiss時のアニメーションを定義したクラスを返却
        return DismissAnimator()
    }

    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        /// インタラクション開始している場合にはinteractorを返却する
        /// 開始していない場合はnilを返却することでインタラクション無しのdissmissとなる
        switch interactor.state {
        case .hasStarted, .shouldFinish:
            return interactor
        case .none, .shouldStart:
            return nil
        }
    }
}
