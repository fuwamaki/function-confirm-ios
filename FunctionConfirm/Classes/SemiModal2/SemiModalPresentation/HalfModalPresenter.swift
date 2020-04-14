//
//  HalfModalPresenter.swift
//  FunctionConfirm
//
//  Created by yusaku maki on 2020/04/14.
//  Copyright © 2020 牧宥作. All rights reserved.
//

import UIKit

protocol HalfModalPresenter: AnyObject {
    var isHalfModalPresented: Bool { get }
    func presentHalfModal(_ viewControllerToPresent: HalfModalPresentable.LayoutType, sourceView: UIView?, sourceRect: CGRect)
}
