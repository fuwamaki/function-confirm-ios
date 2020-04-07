//
//  SemiModalTestViewController.swift
//  FunctionConfirm
//
//  Created by yusaku maki on 2020/04/03.
//  Copyright © 2020 牧宥作. All rights reserved.
//

import UIKit

final class SemiModalTestViewController: UIViewController {

//    @IBOutlet private weak var backgroundView: SemiModalCustomView! {
//        didSet {
//            /// handle tap backgroundView
//            let gesture = UITapGestureRecognizer(target: self, action: #selector(handleClickBackgroundView))
//            backgroundView.addGestureRecognizer(gesture)
//        }
//    }
//    @objc private func handleClickBackgroundView() {
//        dismiss(animated: true, completion: nil)
//    }

    @IBOutlet private weak var containerStackView: UIStackView!

    @IBOutlet private weak var headerView: UIView! {
        didSet {
            /// headerViewの上部を角丸に
            headerView.layer.cornerRadius = 8.0
            headerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            /// handle swipe headerView
            let headerGesture = UIPanGestureRecognizer(target: self, action: #selector(handleHeaderViewSwipe(_:)))
            headerView.addGestureRecognizer(headerGesture)
        }
    }

    /// HeaderViewをSwipeした場合の処理。即インタラクションを開始。
    @objc private func handleHeaderViewSwipe(_ sender: UIPanGestureRecognizer) {
        interactor.handleSwipeGesture(view: view, sender: sender)
    }

    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.registerForCell(SemiModalTestTableCell.self)
            tableView.tableFooterView = UIView()
            /// handle swipe tableView
            let tableViewGesture = UIPanGestureRecognizer(target: self, action: #selector(handleTableViewSwipe(_:)))
            tableViewGesture.delegate = self
            tableView.addGestureRecognizer(tableViewGesture)
        }
    }

    /// TableViewをSwipeした場合の処理。TableViewのScrollがTopならインタラクションを開始。
    @objc private func handleTableViewSwipe(_ sender: UIPanGestureRecognizer) {
        /// TableViewのScrollがTop位置の場合、interactorの状態を更新
        if tableViewContentOffsetY <= 0 {
            interactor.handleSwipeGesture(view: view, sender: sender)
        } else {
            /// 上に引き上げているとき。
            allHeightConstraint.priority = .defaultHigh
            halfHeightConstraint.priority = .defaultLow
        }
    }

    /// tableView内のスクロール高さ。通常時が0。
    private var tableViewContentOffsetY: CGFloat = 0.0

    private var interactor = OverCurrentTransitioningInteractor()
    private var array: [String] = ["1", "2", "3", "4", "5", "6", "7", "8"]

    private lazy var allHeightConstraint: NSLayoutConstraint = {
        return containerStackView.heightAnchor.constraint(equalTo: containerStackView.superview!.heightAnchor, multiplier: 0.9)
    }()

    private lazy var halfHeightConstraint: NSLayoutConstraint = {
        return containerStackView.heightAnchor.constraint(equalTo: containerStackView.superview!.heightAnchor, multiplier: 0.4)
    }()

    static func make() -> UIViewController {
        let storyBoard = UIStoryboard(name: "SemiModalTest", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "SemiModalTestViewController")
        return viewController
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        transitioningDelegate = self
        modalPresentationStyle = .custom
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        transitioningDelegate = self
        modalPresentationStyle = .custom
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        allHeightConstraint.priority = .defaultHigh
        allHeightConstraint.isActive = true
        halfHeightConstraint.priority = .defaultLow
        halfHeightConstraint.isActive = true
        interactor.startHandler = { [weak self] in
            /// bounces: ScrollViewがコンテンツの端を越えて跳ね返る(bounce)か、また戻るか
            self?.tableView.bounces = false
        }
        interactor.dismissHandler = { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }
        interactor.allStateHandler = { [weak self] in
            self?.tableView.bounces = true
            self?.allHeightConstraint.priority = .defaultHigh
            self?.halfHeightConstraint.priority = .defaultLow
            UIView.animate(withDuration: 1.0) {
                self?.view.layoutIfNeeded()
            }
        }
        interactor.halfStateHandler = { [weak self] in
            self?.tableView.bounces = true
            self?.allHeightConstraint.priority = .defaultLow
            self?.halfHeightConstraint.priority = .defaultHigh
            UIView.animate(withDuration: 1.0) {
                self?.view.layoutIfNeeded()
            }
        }
    }

    private var isAll: Bool = false
    // memo: handleSwipeGestureの.end時にも呼び出され、viewOriginYを更新する
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        interactor.viewOriginY = containerStackView.frame.origin.y
    }
}

// MARK: UITableViewDelegate
extension SemiModalTestViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        tableViewContentOffsetY = scrollView.contentOffset.y
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        allHeightConstraint.priority = isAll ? .defaultHigh : .defaultLow
        halfHeightConstraint.priority = isAll ? .defaultLow : .defaultHigh
        isAll = !isAll
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
    /// 2つ以上のgesture認識を可能にするかどうか
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

// MARK: UIViewControllerTransitioningDelegate
extension SemiModalTestViewController: UIViewControllerTransitioningDelegate {
    /// SemiModalTestViewへの遷移アニメーションを定義
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return SemiModalPresentationController(presentedViewController: presented, presenting: presenting)
    }

    /// SemiModalTestViewを閉じるアニメーションを定義
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SemiModalDismissAnimationController()
    }

    /// SemiModalTestViewを閉じる際に使用するinteractive objectを定義
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.isUseInteractor ? interactor : nil
    }
}
