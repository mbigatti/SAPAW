//
//  GroupAnimationInterfaceController.swift
//  AnimationExample
//
//  Created by Massimiliano Bigatti on 20/07/15.
//  Copyright © 2015 Massimiliano Bigatti. All rights reserved.
//

import WatchKit
import Foundation


class GroupAnimationInterfaceController: WKInterfaceController {
    
    @IBOutlet var spacerGroup: WKInterfaceGroup!
    
    let kAnimationDuration : NSTimeInterval = 0.75
    
    override func didAppear() {
        super.didAppear()
        
        animateWithDuration(self.kAnimationDuration) { () -> Void in
            self.spacerGroup.setWidth(0)
        }
        
    }
    
}
