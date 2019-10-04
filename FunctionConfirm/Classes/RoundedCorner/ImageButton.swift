//
//  ImageButton.swift
//  FunctionConfirm
//
//  Created by yusaku maki on 2019/10/04.
//  Copyright © 2019 牧宥作. All rights reserved.
//

import UIKit

@IBDesignable
final class ImageButton: UIButton {

    @IBInspectable var unselectedImage: UIImage = UIImage()
    @IBInspectable var selectedImage: UIImage = UIImage()

    public var selectedStatus: Bool = false {
        didSet {
            setupImageView()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setupImageView()
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupImageView()
        setNeedsDisplay()
    }

    private func setupImageView() {
        setImage(selectedStatus ? selectedImage : unselectedImage, for: .normal)
        setImage(selectedStatus ? selectedImage : unselectedImage, for: .highlighted)
    }
}
