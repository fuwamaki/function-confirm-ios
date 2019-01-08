//
//  ViewController.swift
//  FunctionConfirm
//
//  Created by 牧宥作 on 2018/06/22.
//  Copyright © 2018 牧宥作. All rights reserved.
//

import UIKit

class MainVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "動作確認"
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension MainVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // ココどうにかしてキレイに書きたい（Dynamic Prototypesとして）
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "pickerCell", for: indexPath)
            cell.textLabel?.text = "PickerView表示(InterfaceBuilder)"
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "codeOnlyPickerCell", for: indexPath)
            cell.textLabel?.text = "PickerView表示(Code)"
            return cell
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "peekAndPopCell", for: indexPath)
            cell.textLabel?.text = "Peek & Pop 機能"
            return cell
        } else if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "GitHubRepositoryListCell", for: indexPath)
            cell.textLabel?.text = "GithubのRepositoryList表示"
            return cell
        } else if indexPath.row == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "QiitaListCell", for: indexPath)
            cell.textLabel?.text = "Qiitaの記事リスト表示"
            return cell
        } else if indexPath.row == 5 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "mvpCell", for: indexPath)
            cell.textLabel?.text = "アーキ確認システム（MVP）"
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "stackviewCell", for: indexPath)
            cell.textLabel?.text = "StackView練習"
            return cell
        }
    }
}

extension MainVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            let storyBoard = UIStoryboard(name: "Picker", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "PickerVC")
            navigationController?.pushViewController(vc, animated: true)
        case 1:
            let storyBoard = UIStoryboard(name: "CodeOnlyPickerViewController", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "CodeOnlyPickerViewController")
            navigationController?.pushViewController(vc, animated: true)
        case 2:
            let storyBoard = UIStoryboard(name: "ScreenTransition", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "ScreenTransitionVC")
            navigationController?.pushViewController(vc, animated: true)
        case 3:
            let storyBoard = UIStoryboard(name: "GitHubRepositoryList", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "GitHubRepositoryListVC")
            navigationController?.pushViewController(vc, animated: true)
        case 4:
            let storyBoard = UIStoryboard(name: "QiitaList", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "QiitaListVC")
            navigationController?.pushViewController(vc, animated: true)
        case 5:
            let storyBoard = UIStoryboard(name: "MVP", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "MVPViewController")
            navigationController?.pushViewController(vc, animated: true)
        case 6:
            let storyBoard = UIStoryboard(name: "StackView", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "StackViewController")
            navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
}
