//
//  HalfModalViewController.swift
//  FunctionConfirm
//
//  Created by yusaku maki on 2020/04/14.
//  Copyright © 2020 牧宥作. All rights reserved.
//

import UIKit

final class HalfModalViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.registerForCell(SemiModalTestTableCell.self)
            tableView.tableFooterView = UIView()
        }
    }

    private var array: [String] = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20"]

    static func make() -> HalfModalPresentable.LayoutType {
        let storyBoard = UIStoryboard(name: "HalfModalViewController", bundle: nil)
        let viewController: HalfModalPresentable.LayoutType = storyBoard.instantiateViewController(withIdentifier: "HalfModalViewController") as! HalfModalViewController
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension HalfModalViewController: HalfModalPresentable {
    // HalfModalで表示させるViewのUIScrollViewがあれば登録
    var halfScrollable: UIScrollView? {
        return tableView
    }

    var shortFormHeight: HalfModalHeight {
        return .contentHeight(300)
    }

    var longFormHeight: HalfModalHeight {
        return .maxHeightWithTopInset(40)
    }

    var anchorModalToLongForm: Bool {
        return false
    }
}

extension HalfModalViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true, completion: nil)
    }
}

extension HalfModalViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCellForIndexPath(indexPath) as SemiModalTestTableCell
        cell.render(text: array[indexPath.row])
        return cell
    }
}
