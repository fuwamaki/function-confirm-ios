//
//  NewPageControlViewController.swift
//  FunctionConfirm
//
//  Created by fuwamaki on 2022/06/09.
//  Copyright © 2022 fuwamaki. All rights reserved.
//

import UIKit

final class NewPageControlViewController: UIViewController {

    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var pageControl: UIPageControl!

    private var pageViewController: UIPageViewController?
    private var viewControllers: [UIViewController] = [
        TestChildViewController.make(text: "First"),
        TestChildViewController.make(text: "Second")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    private func setupViews() {
        let viewController = children[0] as? UIPageViewController
        pageViewController = viewController
        pageViewController?.setViewControllers(
            [viewControllers[0]],
            direction: .forward,
            animated: false,
            completion: nil
        )
        pageViewController?.dataSource = self
        pageViewController?.delegate = self
    }
}

// MARK: UIPageViewControllerDataSource
extension NewPageControlViewController: UIPageViewControllerDataSource {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        let index = viewControllers.firstIndex(of: viewController) ?? 0
        return index > 0 ? viewControllers[0] : nil
    }

    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        let index = viewControllers.firstIndex(of: viewController) ?? 0
        return index < viewControllers.count-1 ? viewControllers[1] : nil
    }
}

// MARK: UIPageViewControllerDelegate
extension NewPageControlViewController: UIPageViewControllerDelegate {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {}
}
