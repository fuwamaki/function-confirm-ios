//
//  MenuViewController.swift
//  FunctionConfirm
//
//  Created by fuwamaki on 2022/04/26.
//  Copyright © 2022 fuwamaki. All rights reserved.
//

import UIKit

enum MenuType: CaseIterable {
    case pppppp
    case akane
    case sakamoto

    var title: String {
        switch self {
        case .pppppp:
            return "PPPPPP"
        case .akane:
            return "あかね噺"
        case .sakamoto:
            return "Sakamoto Days"
        }
    }
}

final class MenuViewController: UIViewController {

    @IBOutlet private weak var sampleButton: UIButton!

    private var selectedMenuType = MenuType.pppppp

    override func viewDidLoad() {
        super.viewDidLoad()
        configureMenuButton()
    }

    private func configureMenuButton() {
        let actions = MenuType.allCases
            .compactMap { type in
                UIAction(
                    title: type.title,
                    state: type == selectedMenuType ? .on : .off,
                    handler: { _ in
                        self.selectedMenuType = type
                        self.configureMenuButton()
                    })
            }
        sampleButton.menu = UIMenu(title: "", options: .displayInline, children: actions)
        sampleButton.showsMenuAsPrimaryAction = true
        sampleButton.setTitle(selectedMenuType.title, for: .normal)
    }
}
