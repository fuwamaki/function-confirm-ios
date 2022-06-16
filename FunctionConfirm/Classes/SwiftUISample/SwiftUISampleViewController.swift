//
//  SwiftUISampleViewController.swift
//  FunctionConfirm
//
//  Created by fuwamaki on 2022/06/16.
//  Copyright © 2022 fuwamaki. All rights reserved.
//

import UIKit
import SwiftUI

final class SwiftUISampleViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(
                SwiftUISampleTableCell.self,
                forCellReuseIdentifier: "cell"
            )
        }
    }

    private var list: [SwiftUISampleData] = [
        SwiftUISampleData(name: "Apple", isFavorited: false),
        SwiftUISampleData(name: "Banana", isFavorited: false),
        SwiftUISampleData(name: "Lemon", isFavorited: false)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: UITableViewDataSource
extension SwiftUISampleViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return list.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "cell",
            for: indexPath
        )
        let data = list[indexPath.row]
        cell.contentConfiguration = UIHostingConfiguration {
            HStack {
                Text(data.name)
                Spacer()
                Image(systemName: data.favoriteImageName)
            }
        }
        return cell
    }
}

// MARK: UITableViewDelegate
extension SwiftUISampleViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: true)
        list[indexPath.row].isFavorited.toggle()
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

class SwiftUISampleTableCell: UITableViewCell {}
