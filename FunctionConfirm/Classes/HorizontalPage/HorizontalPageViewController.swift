//
//  HorizontalPageViewController.swift
//  HorizontalPageViewController
//
//  Created by yusaku maki on 2021/08/20.
//  Copyright © 2021 fuwamaki. All rights reserved.
//

import UIKit

final class HorizontalPageViewController: UIViewController {

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

    private let scrollHeight: CGFloat = 200.0
    private let imageWidth: CGFloat = UIScreen.main.bounds.width

    private var fixedImages: [UIImage] {
        return [UIImage(named: "img_entertainment")!,
                UIImage(named: "img_service")!,
                UIImage(named: "img_technology")!]
    }
    private lazy var imageList: [UIImage] = {
        return fixedImages + fixedImages + fixedImages + fixedImages
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupImages()
    }

    private func setupImages() {
        sampleScrollView.subviews.forEach {
            $0.removeFromSuperview()
        }
        imageList.enumerated().forEach { index, image in
            let imageView = UIImageView(frame: CGRect(x: imageWidth * CGFloat(index),
                                                      y: 0,
                                                      width: imageWidth,
                                                      height: scrollHeight))
            imageView.image = image
            imageView.contentMode = .scaleAspectFill
            sampleScrollView.addSubview(imageView)
        }
        sampleScrollView.contentSize = CGSize(width: imageWidth * CGFloat(imageList.count),
                                              height: scrollHeight)
        samplePageControl.numberOfPages = fixedImages.count
    }
}

// MARK: UIScrollViewDelegate
extension HorizontalPageViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x > imageWidth * 1.5 {
            // 先頭要素を末尾に
            if let first = self.imageList.first {
                self.imageList.append(first)
                self.imageList.removeFirst()
            }
            // 再描画
            setupImages()
            // contentOffsetの調整
            self.sampleScrollView.contentOffset.x -= imageWidth
            // pageControlのcurrent更新
            samplePageControl.currentPage = fixedImages.firstIndex(of: imageList[1])!
        }
        if sampleScrollView.contentOffset.x < imageWidth * 0.5 {
            // 末尾要素を先頭に
            if let last = self.imageList.last {
                self.imageList.insert(last, at: 0)
                self.imageList.removeLast()
            }
            // 再描画
            setupImages()
            // contentOffsetの調整
            self.sampleScrollView.contentOffset.x += imageWidth
            // pageControlのcurrent更新
            samplePageControl.currentPage = fixedImages.firstIndex(of: imageList[1])!
        }
    }
}
