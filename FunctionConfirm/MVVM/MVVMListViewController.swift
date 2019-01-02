//
//  MVVMListViewController.swift
//  FunctionConfirm
//
//  Created by Maki, Yusaku | Mackey | ECID on 2018/12/29.
//  Copyright © 2018年 牧宥作. All rights reserved.
//

import UIKit
import RxSwift

class MVVMListViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!

    private lazy var viewModel: MVVMListViewModel = {
        return MVVMListViewModel(viewController: self)
    }()

    override func viewDidLoad() {
        setupTableView()
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.baseGray
    }
}

extension MVVMListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MVPTableCell", for: indexPath)
        return cell
    }
}

extension MVVMListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension MVVMListViewController: StoryboardLoadable {}
