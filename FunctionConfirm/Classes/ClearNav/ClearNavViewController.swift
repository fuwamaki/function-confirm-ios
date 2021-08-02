//
//  ClearNavViewController.swift
//  FunctionConfirm
//
//  Created by yusaku maki on 2021/07/24.
//  Copyright © 2021 fuwamaki. All rights reserved.
//

import UIKit

final class ClearNavViewController: UIViewController {

    private lazy var favoriteBarButtonItem: UIBarButtonItem = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "blue_star")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        return UIBarButtonItem(customView: button)
    }()

    private lazy var triangleBarButtonItem: UIBarButtonItem = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "blue_triangle")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        return UIBarButtonItem(customView: button)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.setRightBarButtonItems([triangleBarButtonItem, favoriteBarButtonItem], animated: false)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
}
