//
//  FadeScrollViewController.swift
//  FunctionConfirm
//
//  Created by fuwamaki on 2022/05/05.
//  Copyright © 2022 fuwamaki. All rights reserved.
//

import UIKit

final class FadeScrollViewController: UIViewController {

    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var fadeView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
    }
}

// MARK: UIScrollViewDelegate
extension FadeScrollViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let scrollHeight = scrollView.contentSize.height
        let screenHeight = scrollView.bounds.size.height
        let length = scrollHeight - screenHeight
        fadeView.alpha = 1 - (offsetY / length)
    }
}
