//
//  MVPViewController.swift
//  FunctionConfirm
//
//  Created by Maki, Yusaku | Mackey | ECID on 8/7/18.
//  Copyright © 2018 牧宥作. All rights reserved.
//

import UIKit

class MVPViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "MVP"
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension MVPViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MVPCell", for: indexPath)
        cell.textLabel?.text = "さんぷる"
        return cell
    }
}

extension MVPViewController: UITableViewDataSource {
}
