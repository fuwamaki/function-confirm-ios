//
//  AnimationPageViewController.swift
//  FunctionConfirm
//
//  Created by Maki, Yusaku | Mackey | ECID on 2019/02/14.
//  Copyright © 2019年 牧宥作. All rights reserved.
//

import UIKit

final class AnimationPageViewController: UIPageViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setViewControllers([getFirst()], direction: .forward, animated: true, completion: nil)
        dataSource = self
    }

    func getFirst() -> UIViewController {
        let storyBoard = UIStoryboard(name: "Animation", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "AnimationFirstViewController")
        return viewController
    }

    func getSecond() -> UIViewController {
        let storyBoard = UIStoryboard(name: "Animation", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "AnimationSecondViewController")
        return viewController
    }

    func getThird() -> UIViewController {
        let storyBoard = UIStoryboard(name: "Animation", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "AnimationThirdViewController")
        return viewController
    }
}

extension AnimationPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if viewController.isKind(of: AnimationThirdViewController.self) {
            return getSecond()
        } else if viewController.isKind(of: AnimationSecondViewController.self) {
            return getFirst()
        } else {
            return nil
        }
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if viewController.isKind(of: AnimationFirstViewController.self) {
            return getSecond()
        } else if viewController.isKind(of: AnimationSecondViewController.self) {
            return getThird()
        } else {
            return nil
        }
    }
}
