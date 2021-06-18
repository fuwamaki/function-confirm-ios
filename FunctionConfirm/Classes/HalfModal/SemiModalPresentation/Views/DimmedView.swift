//
//  DimmedView.swift
//  FunctionConfirm
//
//  Created by yusaku maki on 2020/04/14.
//  Copyright © 2020 牧宥作. All rights reserved.
//

import UIKit

class DimmedView: UIView {

    enum DimState {
        case max
        case off
        case percent(CGFloat)
    }

    var dimState: DimState = .off {
        didSet {
            switch dimState {
            case .max: alpha = 1.0
            case .off: alpha = 0.0
            case .percent(let percentage): alpha = max(0.0, min(1.0, percentage))
            }
        }
    }

    var didTap: ((_ recognizer: UIGestureRecognizer) -> Void)?

    private lazy var tapGesture: UIGestureRecognizer = {
        return UITapGestureRecognizer(target: self, action: #selector(didTapView))
    }()

    init(dimColor: UIColor = UIColor.black.withAlphaComponent(0.7)) {
        super.init(frame: .zero)
        alpha = 0.0
        backgroundColor = dimColor
        addGestureRecognizer(tapGesture)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    @objc private func didTapView() {
        didTap?(tapGesture)
    }
}
