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
            sampleScrollView.isPagingEnabled = false
            sampleScrollView.showsHorizontalScrollIndicator = false
        }
    }
    @IBOutlet private weak var samplePageControl: UIPageControl! {
        didSet {
            samplePageControl.isUserInteractionEnabled = false
        }
    }

    private let scrollHeight: CGFloat = 200.0

    // 飛び出して見えている画像の横幅
    private let protrudingWidth: CGFloat = 16.0
    // 画像の間隔
    private let spaceBetweenImages: CGFloat = 16.0

    // 画像の横幅
    private var imageWidth: CGFloat {
        return UIScreen.main.bounds.width - ((protrudingWidth + spaceBetweenImages) * 2)
    }

    // ページの横幅
    private var pageWidth: CGFloat {
        return imageWidth + spaceBetweenImages
    }

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
            let imageView = UIImageView(frame: CGRect(x: pageWidth * CGFloat(index)
                                                      + protrudingWidth
                                                      + spaceBetweenImages,
                                                      y: 0,
                                                      width: imageWidth,
                                                      height: scrollHeight))
            imageView.image = image
            imageView.contentMode = .scaleAspectFill
            sampleScrollView.addSubview(imageView)
        }
        sampleScrollView.contentSize = CGSize(width: pageWidth * CGFloat(imageList.count),
                                              height: scrollHeight)
        samplePageControl.numberOfPages = fixedImages.count
    }
}

// MARK: UIScrollViewDelegate
extension HorizontalPageViewController: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                   withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        // ドラッグを離した時の、ScrollView内における左端位置
        let positionXOfScroll: CGFloat = scrollView.contentOffset.x
        // 各Pageの、ScrollView内における左端位置の配列
        let positionXOfPages: [CGFloat] = scrollView.subviews
            .map { $0.frame.minX - (protrudingWidth + spaceBetweenImages) }
        // ドラッグを離した時に、自動スクロールセットしたいPageの左端位置
        let targetPositionX = positionXOfPages
            .min(by: { abs($0 - positionXOfScroll) <= abs($1 - positionXOfScroll) })!
        if abs(velocity.x) < 0.2 {
            // 勢いがないスクロールなら、targetPositionXに
            targetContentOffset.pointee.x = targetPositionX
        } else if velocity.x < 0,
                  let positionX = positionXOfPages.filter({ $0 < positionXOfScroll }).max() {
            // 左方向への勢いがあれば、左側のPageに
            // memo: 0だと正常に機能しないので、0に近くて0ではない値に
            targetContentOffset.pointee.x = (positionX == 0) ? 1 : positionX
        } else if velocity.x > 0,
                  let positionX = positionXOfPages.filter({ $0 > positionXOfScroll }).min() {
            // 右方向への勢いがあれば、右側のPageに
            targetContentOffset.pointee.x = positionX
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x > pageWidth * 1.5 {
            // 先頭要素を末尾に
            if let first = imageList.first {
                imageList.append(first)
                imageList.removeFirst()
            }
            // 再描画
            setupImages()
            // contentOffsetの調整
            sampleScrollView.contentOffset.x -= pageWidth
            // pageControlのcurrent更新
            samplePageControl.currentPage = fixedImages.firstIndex(of: imageList[1])!
        }
        if sampleScrollView.contentOffset.x < pageWidth * 0.5 {
            // 末尾要素を先頭に
            if let last = imageList.last {
                imageList.insert(last, at: 0)
                imageList.removeLast()
            }
            // 再描画
            setupImages()
            // contentOffsetの調整
            sampleScrollView.contentOffset.x += pageWidth
            // pageControlのcurrent更新
            samplePageControl.currentPage = fixedImages.firstIndex(of: imageList[1])!
        }
    }
}
