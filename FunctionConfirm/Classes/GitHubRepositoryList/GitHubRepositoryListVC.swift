//
//  GitHubRepositoryListVC.swift
//  FunctionConfirm
//
//  Created by y-maki on 2018/06/25.
//  Copyright © 2018年 牧宥作. All rights reserved.
//

import UIKit
import SafariServices

class GitHubRepositoryListVC: UIViewController, gitHubRepositoryListUserInterface {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!

    private var eventHandler: gitHubRepositoryListEventHandler?
    private var repositoryItems: [Repository] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        let gitHubRepositoryModel = GitHubRepositoryModel()
        self.eventHandler = gitHubRepositoryModel
        gitHubRepositoryModel.userInterface = self

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "GitHubRepositoryListCell")
    }

    @IBAction func searchTouchUpInside(_ sender: Any) {
        if let inputText = textField.text {
            requestGitHubRepositoryList(inputText)
        }
    }

    @IBAction func descTouchUpInside(_ sender: Any) {
        self.repositoryItems.sort(by: { (val1, val2) -> Bool in
            val1.stargazersCount > val2.stargazersCount
        })
        reloadItemsView()

    }
    @IBAction func ascTouchUpInside(_ sender: Any) {
        self.repositoryItems.sort(by: { (val1, val2) -> Bool in
            val1.stargazersCount < val2.stargazersCount
        })
        reloadItemsView()
    }

    private func requestGitHubRepositoryList(_ programmingLanguage: String) {
        eventHandler?.getGitHubRepositoryList(programmingLanguage)
    }

    private func reloadItemsView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    private func loadGitHubRepositoryImages() {
        for items in repositoryItems {
            eventHandler?.getRepositoryImageList(id: items.id, imageUrl: items.avatarUrl)
        }
    }

    func loadGitHubRepositoryList(_ items: [Repository]?) {
        if let items = items {
            repositoryItems = items
        } else {
            repositoryItems = []
        }
        loadGitHubRepositoryImages()
    }

    func registItemImage(id: Int, image: UIImage) {
        for i in 0..<repositoryItems.count where repositoryItems[i].id == id {
            repositoryItems[i].image = image
        }
        reloadItemsView()
    }

    func showErrorAlert(_ errorMessage: String) {
        let alert = UIAlertController(
            title: "エラー",
            message: errorMessage,
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "閉じる", style: .default))
        DispatchQueue.main.sync {
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension GitHubRepositoryListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositoryItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GitHubRepositoryListCell", for: indexPath)
        cell.textLabel?.text = repositoryItems[indexPath.row].fullName
        cell.detailTextLabel?.text = String("Star数:\(repositoryItems[indexPath.row].stargazersCount)")
        if let image = repositoryItems[indexPath.row].image {
            cell.imageView?.image = image
        }
        return cell
    }
}

extension GitHubRepositoryListVC: UITableViewDataSource {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let safariVC = SFSafariViewController(url: repositoryItems[indexPath.row].htmlUrl)
        present(safariVC, animated: true, completion: nil)
    }
}

class CustomTableViewCell: UITableViewCell {
    override func prepareForReuse() {
        imageView?.image = nil
    }
}
