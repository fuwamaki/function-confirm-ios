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

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "商品一覧"
        setupTableView()
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerForCell(MVPTableCell.self)
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
}
