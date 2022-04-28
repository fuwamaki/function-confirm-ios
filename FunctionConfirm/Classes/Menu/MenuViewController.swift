//
//  MenuViewController.swift
//  FunctionConfirm
//
//  Created by fuwamaki on 2022/04/26.
//  Copyright © 2022 fuwamaki. All rights reserved.
//

import UIKit

enum MenuType: CaseIterable {
    case ios
    case android
    case web

    var title: String {
        switch self {
        case .ios:
            return "iOS"
        case .android:
            return "Android"
        case .web:
            return "Web"
        }
    }
}

final class MenuViewController: UIViewController {

    @IBOutlet private weak var sampleBarButtonItem: UIBarButtonItem!
    @IBOutlet private weak var sampleButton: UIButton!

    private var selectedMenuType = MenuType.ios

    override func viewDidLoad() {
        super.viewDidLoad()
        configureMenu()
    }

    private func configureMenu() {
        let actions = MenuType.allCases
            .compactMap { type in
                UIAction(
                    title: type.title,
                    state: type == selectedMenuType ? .on : .off,
                    handler: { _ in
                        self.selectedMenuType = type
                        self.configureMenu()
                    })
            }
        sampleButton.menu = UIMenu(title: "", options: .displayInline, children: actions)
        sampleButton.showsMenuAsPrimaryAction = true
        sampleButton.setTitle(selectedMenuType.title, for: .normal)
    }

//    private func configureMenu() {
//        let actions = MenuType.allCases
//            .compactMap { type in
//                UIAction(
//                    title: type.title,
//                    state: type == selectedMenuType ? .on : .off,
//                    handler: { _ in
//                        self.selectedMenuType = type
//                        self.configureMenu()
//                    })
//            }
//        sampleBarButtonItem.menu = UIMenu(title: "", options: .displayInline, children: actions)
//        sampleBarButtonItem.title = selectedMenuType.title
//    }
}
