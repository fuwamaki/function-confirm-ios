//
//  DisplayVC.swift
//  FunctionConfirm
//
//  Created by y-maki on 2018/06/25.
//  Copyright © 2018年 牧宥作. All rights reserved.
//

import UIKit

class DisplayVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override var previewActionItems: [UIPreviewActionItem] {
        let backAction = UIPreviewAction(title: "戻る", style: .default) { _, _ in
            self.dismiss(animated: true, completion: nil)
        }
        return [backAction]
    }
}
