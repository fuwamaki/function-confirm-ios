//
//  ScreenTransitionVC.swift
//  FunctionConfirm
//
//  Created by y-maki on 2018/06/25.
//  Copyright © 2018年 牧宥作. All rights reserved.
//

import UIKit

class ScreenTransitionVC: UIViewController {
    
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // MEMO: 3DTouch対応端末かどうか判定して、Peek&Popを有効化
        if self.traitCollection.forceTouchCapability == UIForceTouchCapability.available {
            self.registerForPreviewing(with: self, sourceView: self.view)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func nextTouchUpInside(_ sender: Any) {
        transitionToSecondVC()
    }
    
    func transitionToSecondVC() {
        self.performSegue(withIdentifier: "toDisplayVC", sender: nil)
    }
}

extension ScreenTransitionVC: UIViewControllerPreviewingDelegate {
    
    // peek action
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        // MEMO: 押下している範囲がボタン内かどうか判定
        let point: CGPoint = nextButton.convert(location, from: self.view)
        guard point.x > 0, point.x < nextButton.bounds.width, point.y > 0, point.y < nextButton.bounds.height else {
            return nil
        }
        
        let storyBoard = UIStoryboard(name: "ScreenTransition", bundle: nil)
        let secondVC = storyBoard.instantiateViewController(withIdentifier: "DisplayVC")
        return secondVC
    }
    
    // pop action
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        transitionToSecondVC()
    }
}
