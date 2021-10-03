//
//  CustomCanvasView.swift
//  FunctionConfirm
//
//  Created by yusaku maki on 2021/10/03.
//  Copyright © 2021 fuwamaki. All rights reserved.
//

import UIKit
import PencilKit

final class CustomCanvasView: PKCanvasView {
    private var prevEventTime: TimeInterval?

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let aTouch: UITouch = touches.first!
        let location = aTouch.location(in: self)
        let prevLocation = aTouch.previousLocation(in: self)
        if let eventTime = event?.timestamp, let prev = prevEventTime {
            let time = CGFloat(eventTime - prev)
            let distance = sqrt(pow((location.x-prevLocation.x), 2)
                                    + pow((location.y-prevLocation.y), 2))
            print("velocity: \(distance/time)")
        }
        prevEventTime = event?.timestamp
    }
}
