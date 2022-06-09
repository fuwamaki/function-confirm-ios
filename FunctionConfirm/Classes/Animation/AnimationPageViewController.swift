//
//  AnimationPageViewController.swift
//  FunctionConfirm
//
//  Created by Maki, Yusaku | Mackey | ECID on 2019/02/14.
//  Copyright © 2019年 牧宥作. All rights reserved.
//

import UIKit

// 全般的にこれを参考に: https://qiita.com/hachinobu/items/57d4c305c907805b4a53
final class AnimationPageViewController: UIPageViewController {

    private var pageControl: UIPageControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        dataSource = self
        setupPageControl()
        setupFirstViewController()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(clickNextButton))
    }

    private func setupFirstViewController() {
        let firstViewController = getFirst()
        setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        updatePageInfo(currentViewController: firstViewController)
    }

    private func setupPageControl() {
        pageControl = UIPageControl(frame: CGRect(
            x: 0,
            y: self.view.frame.height - 100,
            width: self.view.frame.width,
            height: 50
        ))
        pageControl.backgroundColor = UIColor.systemBackground
        pageControl.currentPageIndicatorTintColor = UIColor.red
        pageControl.pageIndicatorTintColor = UIColor.black
        pageControl.numberOfPages = 8 // ページ数
        pageControl.currentPage = 0
        pageControl.isUserInteractionEnabled = false
        view.addSubview(pageControl)
    }

    // ボタンでも画面遷移できるように
    // swiftlint:disable function_body_length
    // swiftlint:disable cyclomatic_complexity
    @objc private func clickNextButton() {
        guard let currentViewController = viewControllers?[0] else {
            return
        }
        switch currentViewController {
        case is AnimationFirstViewController:
            setViewControllers([getSecond()], direction: .forward, animated: true) { [weak self] _ in
                guard let nextViewController = self?.viewControllers?[0] else {
                    return
                }
                self?.updatePageInfo(currentViewController: nextViewController)
            }
        case is AnimationSecondViewController:
            setViewControllers([getThird()], direction: .forward, animated: true) { [weak self] _ in
                guard let nextViewController = self?.viewControllers?[0] else {
                    return
                }
                self?.updatePageInfo(currentViewController: nextViewController)
            }
        case is AnimationThirdViewController:
            setViewControllers([getFourth()], direction: .forward, animated: true) { [weak self] _ in
                guard let nextViewController = self?.viewControllers?[0] else {
                    return
                }
                self?.updatePageInfo(currentViewController: nextViewController)
            }
        case is AnimationFourthViewController:
            setViewControllers([getFifth()], direction: .forward, animated: true) { [weak self] _ in
                guard let nextViewController = self?.viewControllers?[0] else {
                    return
                }
                self?.updatePageInfo(currentViewController: nextViewController)
            }
        case is AnimationFifthViewController:
            setViewControllers([getSixth()], direction: .forward, animated: true) { [weak self] _ in
                guard let nextViewController = self?.viewControllers?[0] else {
                    return
                }
                self?.updatePageInfo(currentViewController: nextViewController)
            }
        case is AnimationSixthViewController:
            setViewControllers([getSeventh()], direction: .forward, animated: true) { [weak self] _ in
                guard let nextViewController = self?.viewControllers?[0] else {
                    return
                }
                self?.updatePageInfo(currentViewController: nextViewController)
            }
        case is AnimationSeventhViewController:
            setViewControllers([getEighth()], direction: .forward, animated: true) { [weak self] _ in
                guard let nextViewController = self?.viewControllers?[0] else {
                    return
                }
                self?.updatePageInfo(currentViewController: nextViewController)
            }
        case is AnimationEighthViewController:
            setViewControllers([getFirst()], direction: .forward, animated: true) { [weak self] _ in
                guard let nextViewController = self?.viewControllers?[0] else {
                    return
                }
                self?.updatePageInfo(currentViewController: nextViewController)
            }
        default:
            break
        }
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

    private func getFourth() -> UIViewController {
        let storyBoard = UIStoryboard(name: "Animation", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "AnimationFourthViewController")
        return viewController
    }

    private func getFifth() -> UIViewController {
        let storyBoard = UIStoryboard(name: "Animation", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "AnimationFifthViewController")
        return viewController
    }

    private func getSixth() -> UIViewController {
        let storyBoard = UIStoryboard(name: "Animation", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "AnimationSixthViewController")
        return viewController
    }

    private func getSeventh() -> UIViewController {
        let storyBoard = UIStoryboard(name: "Animation", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "AnimationSeventhViewController")
        return viewController
    }

    private func getEighth() -> UIViewController {
        let storyBoard = UIStoryboard(name: "Animation", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "AnimationEighthViewController")
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
        case is AnimationFourthViewController:
            navigationItem.title = "Animation Fourth"
            pageControl.currentPage = 3
        case is AnimationFifthViewController:
            navigationItem.title = "Animation Fifth"
            pageControl.currentPage = 4
        case is AnimationSixthViewController:
            navigationItem.title = "Animation Sixth"
            pageControl.currentPage = 5
        case is AnimationSeventhViewController:
            navigationItem.title = "Animation Seventh"
            pageControl.currentPage = 6
        case is AnimationEighthViewController:
            navigationItem.title = "Animation Eighth"
            pageControl.currentPage = 7
        default:
            break
        }
    }
}

extension AnimationPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if viewController.isKind(of: AnimationEighthViewController.self) {
            return getSeventh()
        } else if viewController.isKind(of: AnimationSeventhViewController.self) {
            return getSixth()
        } else if viewController.isKind(of: AnimationSixthViewController.self) {
            return getFifth()
        } else if viewController.isKind(of: AnimationFifthViewController.self) {
            return getFourth()
        } else if viewController.isKind(of: AnimationFourthViewController.self) {
            return getThird()
        } else if viewController.isKind(of: AnimationThirdViewController.self) {
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
        } else if viewController.isKind(of: AnimationThirdViewController.self) {
            return getFourth()
        } else if viewController.isKind(of: AnimationFourthViewController.self) {
            return getFifth()
        } else if viewController.isKind(of: AnimationFifthViewController.self) {
            return getSixth()
        } else if viewController.isKind(of: AnimationSixthViewController.self) {
            return getSeventh()
        } else if viewController.isKind(of: AnimationSeventhViewController.self) {
            return getEighth()
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
