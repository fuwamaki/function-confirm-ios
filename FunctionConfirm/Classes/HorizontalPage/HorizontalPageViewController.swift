//
//  HorizontalPageViewController.swift
//  HorizontalPageViewController
//
//  Created by yusaku maki on 2021/08/20.
//  Copyright © 2021 fuwamaki. All rights reserved.
//

import UIKit

final class HorizontalPageViewController: UIViewController {

    @IBAction func clickBackButton(_ sender: Any) {
        if (sampleScrollView.contentOffset.x - UIScreen.main.bounds.width) > 0 {
            UIView.animate(withDuration: 0.4) {
                self.sampleScrollView.contentOffset.x -= UIScreen.main.bounds.width
            }
        }
    }

    @IBAction func clickForwardButton(_ sender: Any) {
        if (sampleScrollView.contentOffset.x + UIScreen.main.bounds.width) < sampleScrollView.contentSize.width {
            UIView.animate(withDuration: 0.4) {
                self.sampleScrollView.contentOffset.x += UIScreen.main.bounds.width
            }
        }
    }

    @IBOutlet private weak var sampleScrollView: UIScrollView! {
        didSet {
            sampleScrollView.delegate = self
            sampleScrollView.isPagingEnabled = true
            sampleScrollView.showsHorizontalScrollIndicator = false
        }
    }
    @IBOutlet private weak var samplePageControl: UIPageControl! {
        didSet {
            samplePageControl.isUserInteractionEnabled = false
        }
    }

    private lazy var images: [UIImage] = {
        return [UIImage(named: "img_entertainment")!,
                UIImage(named: "img_service")!,
                UIImage(named: "img_technology")!]
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupImages()
    }

    private func setupImages() {
        sampleScrollView.subviews.forEach {
            $0.removeFromSuperview()
        }
        images.enumerated().forEach { index, image in
            let imageView = UIImageView(
                frame: CGRect(
                    x: UIScreen.main.bounds.width * CGFloat(index),
                    y: 0,
                    width: UIScreen.main.bounds.width,
                    height: 200))
            imageView.image = image
            imageView.contentMode = .scaleAspectFill
            sampleScrollView.addSubview(imageView)
        }
        sampleScrollView.contentSize = CGSize(
            width: UIScreen.main.bounds.width * CGFloat(images.count),
            height: 200)
        samplePageControl.numberOfPages = images.count
    }
}

// MARK: UIScrollViewDelegate
extension HorizontalPageViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        samplePageControl.currentPage = Int(scrollView.contentOffset.x / scrollView.frame.width)
    }
}
