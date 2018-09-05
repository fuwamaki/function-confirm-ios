//
//  MVPViewController.swift
//  FunctionConfirm
//
//  Created by Maki, Yusaku | Mackey | ECID on 8/7/18.
//  Copyright © 2018 牧宥作. All rights reserved.
//

import UIKit
import KRProgressHUD

protocol MVPView: class {
    func reloadData()
}

private struct Text {
    static let title = "商品一覧"
    static let regist = "登録"
}

class MVPViewController: UIViewController, MVPView {

    @IBOutlet weak var tableView: UITableView!
    private var presenter: MVPPresentable!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        presenter = MVPPresenter.init(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = Text.title
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: Text.regist, style: .plain, target: self, action: #selector(clickRegistButton(_:)))
        setupTableView()
        updateItems()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        updateItems()
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerForCell(MVPTableCell.self)
        tableView.backgroundColor = UIColor.baseGray
    }

    private func updateItems() {
        KRProgressHUD.show()
        presenter.updateItems()
    }

    @objc func clickRegistButton(_ sender: UIBarButtonItem) {
        let vc = MVPRegistViewController()
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true, completion: nil)
    }

    func reloadData() {
        KRProgressHUD.dismiss()
        tableView.reloadData()
    }
}

extension MVPViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfItems
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCellForIndexPath(indexPath) as MVPTableCell
        cell.setItem(presenter.entity(at: indexPath))
        return cell
    }
}

extension MVPViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
