//
//  QiitaListVC.swift
//  FunctionConfirm
//
//  Created by y-maki on 2018/06/26.
//  Copyright © 2018年 牧宥作. All rights reserved.
//

import UIKit
import SafariServices

class QiitaListViewController: UIViewController, QiitaListUserInterface {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!

    private var eventHandler: QiitaListEventHandler?
    private var qiitaListElements: [QiitaListElement]?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Qiitaの記事リスト表示"

        let qiitaListViewModel = QiitaListViewModel()
        let qiitaListModel = QiitaListModel()
        qiitaListViewModel.interactable = qiitaListModel
        qiitaListViewModel.userInterface = self
        qiitaListModel.delegate = qiitaListViewModel
        eventHandler = qiitaListViewModel

        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self

        searchBar.text = "検索バー未使用、表示直後にqiitaAPIのタイトル一覧表示"
        eventHandler?.getQiitaList()
    }

    func setQiitaListElements(_ elements: [QiitaListElement]) {
        qiitaListElements = elements
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    func showAlert(message: String) {
        let alert = UIAlertController(
            title: "エラー",
            message: message,
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "閉じる", style: .default))
        DispatchQueue.main.sync {
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension QiitaListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let elements = qiitaListElements {
            return elements.count
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QiitaListCell", for: indexPath)
        if let elements = qiitaListElements {
            cell.textLabel?.text = elements[indexPath.row].title
        }
        return cell
    }
}

extension QiitaListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let elements = qiitaListElements, let url = URL(string: elements[indexPath.row].url) {
            let safariViewController = SFSafariViewController(url: url)
            present(safariViewController, animated: true, completion: nil)
        }
    }
}

extension QiitaListViewController: UISearchBarDelegate {}
