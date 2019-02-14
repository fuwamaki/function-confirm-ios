//
//  AnimationPageViewController.swift
//  FunctionConfirm
//
//  Created by Maki, Yusaku | Mackey | ECID on 2019/02/14.
//  Copyright © 2019年 牧宥作. All rights reserved.
//

import UIKit

final class AnimationPageViewController: UIPageViewController {

    private var pageControl: UIPageControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        dataSource = self
        setupPageControl()
        setupFirstViewController()
    }

    private func setupFirstViewController() {
        let firstViewController = getFirst()
        self.setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        updatePageInfo(currentViewController: firstViewController)
    }

    private func setupPageControl() {
        pageControl = UIPageControl(frame: CGRect(x: 0,
                                                  y: self.view.frame.height - 100,
                                                  width: self.view.frame.width,
                                                  height: 50))
        pageControl.backgroundColor = UIColor.baseGray
        pageControl.currentPageIndicatorTintColor = UIColor.red
        pageControl.pageIndicatorTintColor = UIColor.black
        pageControl.numberOfPages = 3 // ページ数
        pageControl.currentPage = 0
        pageControl.isUserInteractionEnabled = false
        view.addSubview(pageControl)
    }

    private func getFirst() -> UIViewController {
        let storyBoard = UIStoryboard(name: "Animation", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "AnimationFirstViewController")
        return viewController
    }

    private func getSecond() -> UIViewController {
        let storyBoard = UIStoryboard(name: "Animation", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "AnimationSecondViewController")
        return viewController
    }

    private func getThird() -> UIViewController {
        let storyBoard = UIStoryboard(name: "Animation", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "AnimationThirdViewController")
        return viewController
    }

    // ページ情報（navigationのタイトルとpageControl）を更新
    private func updatePageInfo(currentViewController: UIViewController) {
        switch currentViewController {
        case is AnimationFirstViewController:
            navigationItem.title = "Animation First"
            pageControl.currentPage = 0
        case is AnimationSecondViewController:
            navigationItem.title = "Animation Second"
            pageControl.currentPage = 1
        case is AnimationThirdViewController:
            navigationItem.title = "Animation Third"
            pageControl.currentPage = 2
        default:
            break
        }
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
    // MEMO: 上記pageViewControllerメソッドでページ情報の更新するのは適さない。
    // なぜならば、pageViewControllerは、[ページング開始時,ページング完了時]に呼ばれるメソッドだから。
}

extension AnimationPageViewController: UIPageViewControllerDelegate {
    // ページングが完了したらページ情報を更新する
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed, let currentViewController = viewControllers?[0] else {
            return
        }
        updatePageInfo(currentViewController: currentViewController)
    }
}
