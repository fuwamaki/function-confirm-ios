//
//  SimpleListViewController.swift
//  FunctionConfirm
//
//  Created by fuwamaki on 2022/11/10.
//  Copyright © 2022 fuwamaki. All rights reserved.
//

import UIKit

final class SimpleListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }

    private let numbers: [Int] = (0...100).map { $0 }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension SimpleListViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        numbers.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "simpleTableViewCell",
            for: indexPath
        )
        cell.textLabel?.text = numbers[indexPath.row].description
        return cell
    }
}

extension SimpleListViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
