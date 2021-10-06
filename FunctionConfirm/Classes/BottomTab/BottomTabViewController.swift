//
//  BottomTabViewController.swift
//  FunctionConfirm
//
//  Created by yusaku maki on 2021/10/05.
//  Copyright © 2021 fuwamaki. All rights reserved.
//

import UIKit

final class BottomTabViewController: UITabBarController {
    private lazy var scrollEdgeAppearance: UINavigationBarAppearance = {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .yellow
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        return appearance
    }()

    private lazy var standardAppearance: UINavigationBarAppearance = {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .orange
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        return appearance
    }()

    private lazy var compactAppearance: UINavigationBarAppearance = {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .cyan
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        return appearance
    }()

    private lazy var compactScrollEdgeAppearance: UINavigationBarAppearance = {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .blue
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        return appearance
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // CoverView法
//        navigationController?.navigationBar.setBackgroundImage(UIColor.yellow.image, for: .default)
//        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        // RootView法
//        navigationController?.navigationBar.shadowImage = UIImage()
//        navigationController?.navigationBar.backgroundColor = .yellow
//        navigationController?.navigationBar.barTintColor = .white
//        navigationController?.navigationBar.tintColor = .yellow
        // AppearanceView法
//        navigationController?.navigationBar.standardAppearance = standardAppearance
//        navigationController?.navigationBar.scrollEdgeAppearance = scrollEdgeAppearance
//        navigationController?.navigationBar.compactAppearance = compactAppearance
//        if #available(iOS 15.0, *) {
//            navigationController?.navigationBar.compactScrollEdgeAppearance = compactScrollEdgeAppearance
//        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        let appearance = UINavigationBarAppearance()
//        appearance.configureWithOpaqueBackground()
//        appearance.backgroundColor = .orange
//        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
//        navigationController?.navigationBar.standardAppearance = appearance
//        navigationController?.navigationBar.standardAppearance = UINavigationBarAppearance()
//        navigationController?.navigationBar.scrollEdgeAppearance = nil
//        navigationController?.navigationBar.compactAppearance = nil
//        if #available(iOS 15.0, *) {
//            navigationController?.navigationBar.compactScrollEdgeAppearance = nil
//        }
//        navigationController?.navigationBar.standardAppearance = nil
    }
}
