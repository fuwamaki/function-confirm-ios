//
//  Celebrity.swift
//  FunctionConfirm
//
//  Created by Maki, Yusaku | Mackey | ECID on 2019/02/20.
//  Copyright © 2019年 牧宥作. All rights reserved.
//

import UIKit
import SafariServices

final class Celebrity {

    //var parentController: UIViewController! //= UIViewController.init()
    var name: String! //= ""
    var urls: [String]! //= []
    var infoLink: String! //= ""
    var infoLabel: UILabel! //= UILabel.init()

    var boundingBox: CGRect = CGRect(x: 0.0, y: 1.0, width: 0.0, height: 0.0)

    lazy var size: CGSize = {
        let size = CGSize(width: boundingBox.width * celebrityImageView.layer.bounds.width,
                          height: boundingBox.height * celebrityImageView.layer.bounds.height)
        return size
    }()

    lazy var origin: CGPoint = {
        let origin = CGPoint(x: boundingBox.minX * celebrityImageView.layer.bounds.width,
                             y: boundingBox.minY * celebrityImageView.layer.bounds.height)
        return origin
    }()

    lazy var rectangleLayer: CAShapeLayer = {
        let rectangleLayer = CAShapeLayer()
        rectangleLayer.borderColor = UIColor.green.cgColor
        rectangleLayer.borderWidth = 2
        rectangleLayer.frame = CGRect(origin: origin, size: size)
        print("Celebrityのorigin: \(rectangleLayer.frame.origin)")
        print("Celebrityのsize: \(rectangleLayer.frame.size)")
        return rectangleLayer
    }()

    lazy var infoButton: UIButton = {
        let infoButton = UIButton.init(frame: CGRect(origin: CGPoint(x: origin.x, y: origin.y + size.height * 0.75),
                                                     size: CGSize(width: 0.4 * celebrityImageView.layer.bounds.width,
                                                                  height: 0.05 * celebrityImageView.layer.bounds.height)))
        infoButton.backgroundColor = UIColor.black
        infoButton.clipsToBounds = true
        infoButton.layer.cornerRadius = 8
        infoButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
        infoButton.titleLabel?.adjustsFontSizeToFitWidth = true
        infoButton.titleLabel?.textAlignment = NSTextAlignment.center
        infoButton.setTitle(name, for: UIControl.State.normal)
//        infoButton.addTarget(self, action: #selector(handleTap), for: UIControlEvents.touchUpInside)
        return infoButton
    }()

    lazy var celebrityImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        imageView.addSubview(infoButton)
//        imageView.bringSubviewToFront(infoButton)
        return imageView
    }()
}
