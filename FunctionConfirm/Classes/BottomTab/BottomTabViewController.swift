//
//  BottomTabViewController.swift
//  FunctionConfirm
//
//  Created by yusaku maki on 2021/10/05.
//  Copyright © 2021 fuwamaki. All rights reserved.
//

import UIKit

final class BottomTabViewController: UITabBarController {
    // 下にスクロールした時だった
    private lazy var standardAppearance: UINavigationBarAppearance = {
        let appearance = UINavigationBarAppearance()
        // 背景と影をリセットして、テーマに適した不透明な色を表示
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .red
        appearance.titleTextAttributes = [
            .font: UIFont.boldSystemFont(ofSize: 20.0),
            .foregroundColor: UIColor.blue]
        return appearance
    }()

    private lazy var compactAppearance: UINavigationBarAppearance = {
        let appearance = UINavigationBarAppearance()
        // 背景と影をリセットして、テーマに適した不透明な色を表示
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .blue
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        return appearance
    }()

    // 通常の状態
    private lazy var scrollEdgeAppearance: UINavigationBarAppearance = {
        let appearance = UINavigationBarAppearance()
        // 背景と影をリセットして、テーマに適した不透明な色を表示
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .yellow
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        return appearance
    }()

    private lazy var compactScrollEdgeAppearance: UINavigationBarAppearance = {
        let appearance = UINavigationBarAppearance()
        // 背景と影をリセットして、テーマに適した不透明な色を表示
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .black
        appearance.titleTextAttributes = [.foregroundColor: UIColor.red]
        return appearance
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.standardAppearance = standardAppearance
        navigationController?.navigationBar.compactAppearance = compactAppearance
//        navigationController?.navigationBar.scrollEdgeAppearance = scrollEdgeAppearance
        if #available(iOS 15.0, *) {
            navigationController?.navigationBar.compactScrollEdgeAppearance = compactScrollEdgeAppearance
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
//        navigationController?.navigationBar.standardAppearance = nil
    }
}
