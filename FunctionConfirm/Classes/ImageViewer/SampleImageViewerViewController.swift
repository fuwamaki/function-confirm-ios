//
//  SampleImageViewerViewController.swift
//  FunctionConfirm
//
//  Created by yusaku maki on 2021/10/13.
//  Copyright © 2021 fuwamaki. All rights reserved.
//

import UIKit
import ImageViewer

final class SampleImageViewerViewController: UIViewController {

    @IBOutlet private weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(didTap(_:)))
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
    }

    @objc private func didTap(_ sender: UITapGestureRecognizer) {
        let viewController = GalleryViewController(
            startIndex: 0,
            itemsDataSource: self,
            displacedViewsDataSource: self,
            configuration: [
                .deleteButtonMode(.none),
                .thumbnailsButtonMode(.none)
            ])
        presentImageGallery(viewController)
    }
}

// MARK: GalleryItemsDataSource
extension SampleImageViewerViewController: GalleryItemsDataSource {
    func itemCount() -> Int {
        return 1
    }

    func provideGalleryItem(_ index: Int) -> GalleryItem {
        return GalleryItem.image { $0(self.imageView.image!) }
    }
}

// MARK: GalleryDisplacedViewsDataSource
extension SampleImageViewerViewController: GalleryDisplacedViewsDataSource {
    func provideDisplacementItem(atIndex index: Int) -> DisplaceableView? {
        return imageView
    }
}
