//
//  ProgressiveDisplayInterfaceController.swift
//  AnimationExample
//
//  Created by Massimiliano Bigatti on 20/07/15.
//  Copyright © 2015 Massimiliano Bigatti. All rights reserved.
//

import Foundation
import WatchKit

class ProgressiveDisplayInterfaceController: WKInterfaceController {
    
    @IBOutlet var starButton1: WKInterfaceButton!
    @IBOutlet var starButton2: WKInterfaceButton!
    @IBOutlet var starButton3: WKInterfaceButton!
    @IBOutlet var starButton4: WKInterfaceButton!
    
    let kDelayDuration : NSTimeInterval = 0.1
    let kAnimationDuration : NSTimeInterval = 0.25
    let kButtonSize : CGFloat = 32
    
    override func didAppear() {
        super.didAppear()
        
        let starButtons = [starButton1, starButton2, starButton3, starButton4]

        for index in 0..<starButtons.count {
            let delta = Int64(kDelayDuration * Double(NSEC_PER_SEC) * Double(index + 1))
            let completionDelay = dispatch_time(DISPATCH_TIME_NOW, delta)
            
            dispatch_after(completionDelay, dispatch_get_main_queue()) {
                self.animateWithDuration(self.kAnimationDuration) { () -> Void in
                    starButtons[index].setWidth(self.kButtonSize)
                    starButtons[index].setHeight(self.kButtonSize)
                }
            }
        }
        
    }
    
}