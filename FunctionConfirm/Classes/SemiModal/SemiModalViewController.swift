//
//  SemiModalViewController.swift
//  FunctionConfirm
//
//  Created by yusaku maki on 2020/04/03.
//  Copyright © 2020 牧宥作. All rights reserved.
//

import UIKit

final class SemiModalViewController: UIViewController {

    @IBAction private func clickShowModalButton(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "SemiModalTest", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "SemiModalTestViewController")
        viewController.modalPresentationStyle = .custom
        present(viewController, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
