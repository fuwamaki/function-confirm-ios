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

    @IBAction private func clickPageControl(_ sender: UIPageControl) {
        self.pageViewController?.setViewControllers(
            [self.viewControllers[sender.currentPage]],
            direction: .forward,
            animated: false
        )
    }

    private var pageViewController: UIPageViewController?
    private var viewControllers: [UIViewController] = [
        TestChildViewController.make(text: "First"),
        TestChildViewController.make(text: "Second"),
        TestChildViewController.make(text: "Third"),
        TestChildViewController.make(text: "Fourth"),
        TestChildViewController.make(text: "Fifth")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupPageControl()
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

    private func setupPageControl() {
        pageControl.backgroundColor = UIColor.systemBackground
        pageControl.currentPageIndicatorTintColor = UIColor.red
        pageControl.pageIndicatorTintColor = UIColor.black
        pageControl.numberOfPages = viewControllers.count
        pageControl.currentPage = 0
    }
}

// MARK: UIPageViewControllerDataSource
extension NewPageControlViewController: UIPageViewControllerDataSource {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        let index = viewControllers.firstIndex(of: viewController) ?? 0
        return index > 0 ? viewControllers[index-1] : nil
    }

    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        let index = viewControllers.firstIndex(of: viewController) ?? 0
        return index < viewControllers.count-1 ? viewControllers[index+1] : nil
    }
}

// MARK: UIPageViewControllerDelegate
extension NewPageControlViewController: UIPageViewControllerDelegate {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        let index = viewControllers.firstIndex(of: pageViewController.viewControllers![0]) ?? 0
        pageControl.currentPage = index
    }
}
