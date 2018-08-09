//
//  MVPViewController.swift
//  FunctionConfirm
//
//  Created by Maki, Yusaku | Mackey | ECID on 8/7/18.
//  Copyright © 2018 牧宥作. All rights reserved.
//

import UIKit

protocol MVPView: class {
    
}

class MVPViewController: UIViewController {

    private struct Text {
        static let title = "商品一覧"
        static let regist = "登録"
    }

    @IBOutlet weak var tableView: UITableView!
    private var presentable: MVPPresentable?

    override func viewDidLoad() {
        super.viewDidLoad()
        let presenter = MVPPresenter(self)
        presentable = presenter
        navigationItem.title = Text.title
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: Text.regist, style: .plain, target: self, action: #selector(clickRegistButton(_:)))
        setupTableView()
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerForCell(MVPTableCell.self)
        tableView.backgroundColor = UIColor.baseGray
    }

    @objc func clickRegistButton(_ sender: UIBarButtonItem) {
        let vc = MVPRegistViewController()
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true, completion: nil)
    }
}

extension MVPViewController: MVPView {
    
}

extension MVPViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCellForIndexPath(indexPath) as MVPTableCell
        cell.setItem()
        return cell
    }
}

extension MVPViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
