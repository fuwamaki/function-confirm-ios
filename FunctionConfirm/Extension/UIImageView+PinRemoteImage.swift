//
//  UIImageView+PinRemote.swift
//  FunctionConfirm
//
//  Created by yusaku maki on 2021/10/09.
//  Copyright © 2021 fuwamaki. All rights reserved.
//

import UIKit
import PINRemoteImage

extension UIImageView {
    func setImage(urlString: String?, completion: (() -> Void)? = nil) {
        guard let urlString = urlString,
              let url = URL(string: urlString) else { return }
        pin_setImage(from: url) { _ in
            if let completion = completion {
                completion()
            }
        }
    }

    func setImage(url: URL?, completion: (() -> Void)? = nil) {
        guard let url = url else { return }
        pin_setImage(from: url) { _ in
            if let completion = completion {
                completion()
            }
        }
    }

    func setImageWithFade(urlString: String?, completion: (() -> Void)? = nil) {
        guard let urlString = urlString,
              let url = URL(string: urlString) else { return }
        self.pin_setImage(from: url) { [weak self] _ in
            self?.alpha = 0.0
            UIView.animate(withDuration: 0.5, animations: {
                self?.alpha = 1.0
            })
            if let completion = completion {
                completion()
            }
        }
    }

    func setImageWithFade(url: URL?, completion: ((_ image: UIImage?) -> Void)? = nil) {
        guard let url = url else { return }
        self.pin_setImage(from: url) { [weak self] in
            self?.alpha = 0.0
            UIView.animate(withDuration: 0.5, animations: {
                self?.alpha = 1.0
            })
            if let completion = completion {
                completion($0.image)
            }
        }
    }
}
