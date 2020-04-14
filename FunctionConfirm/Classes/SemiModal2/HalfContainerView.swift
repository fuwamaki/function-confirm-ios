//
//  HalfContainerView.swift
//  FunctionConfirm
//
//  Created by yusaku maki on 2020/04/14.
//  Copyright © 2020 牧宥作. All rights reserved.
//

import UIKit

class HalfContainerView: UIView {

    init(presentedView: UIView, frame: CGRect) {
        super.init(frame: frame)
        addSubview(presentedView)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIView {
    var halfContainerView: HalfContainerView? {
        return subviews.first(where: { view -> Bool in
            view is HalfContainerView
        }) as? HalfContainerView
    }
}
