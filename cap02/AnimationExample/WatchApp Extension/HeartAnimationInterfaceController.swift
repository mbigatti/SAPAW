//
//  HeartAnimationInterfaceController.swift
//  AnimationExample
//
//  Created by Massimiliano Bigatti on 20/07/15.
//  Copyright © 2015 Massimiliano Bigatti. All rights reserved.
//

import Foundation
import WatchKit


class HeartAppearInterfaceController: WKInterfaceController {
    
    @IBOutlet var image: WKInterfaceImage!
    
    let kAnimationDuration : NSTimeInterval = 1
    
    override func didAppear() {
        super.didAppear()
        
        animateWithDuration(self.kAnimationDuration) { () -> Void in
            self.image.setAlpha(1)
        }
    }
    
}

class HeartDisappearInterfaceController: WKInterfaceController {
    
    @IBOutlet var image: WKInterfaceImage!
    
    let kAnimationDuration : NSTimeInterval = 1
    
    override func didAppear() {
        super.didAppear()
        
        animateWithDuration(kAnimationDuration) { () -> Void in
            self.image.setHeight(0)
            self.image.setWidth(0)
        }
    }
    
}

class HeartPulseInterfaceController: WKInterfaceController {
    
    @IBOutlet var image: WKInterfaceImage!

    let kAnimationDuration : NSTimeInterval = 1
    let kShapeSize : CGFloat = 100
    let kReductionFactor : CGFloat = 0.95
    let kAlpha1 : CGFloat = 1
    let kAlpha2 : CGFloat = 0.9
    
    var timer : NSTimer?
    var enlarging = true
    
    override func didAppear() {
        super.didAppear()
        
        timer = NSTimer.scheduledTimerWithTimeInterval(kAnimationDuration, target: self, selector: "timerFired", userInfo: nil, repeats: true)
        
        timerFired()
    }
    
    @objc func timerFired() {
        print("timerFired()")
        
        animateWithDuration(kAnimationDuration) { () -> Void in
            self.updateUI(self.enlarging)
        }
        
        enlarging = !enlarging
    }
    
    func updateUI(initialStatus: Bool) {
        if initialStatus {
            self.image.setAlpha(self.kAlpha1)
            self.image.setHeight(self.kShapeSize)
            self.image.setWidth(self.kShapeSize)
            
        } else {
            self.image.setAlpha(self.kAlpha2)
            self.image.setHeight(self.kShapeSize * self.kReductionFactor)
            self.image.setWidth(self.kShapeSize * self.kReductionFactor)
            
        }
    }
    
    override func willDisappear() {
        super.willDisappear()
        timer!.invalidate()
    }
}

class AnimationCompletionInterfaceController: WKInterfaceController {
    
    @IBOutlet var image: WKInterfaceImage!
    
    let kAnimationDuration : NSTimeInterval = 1.5
    
    override func didAppear() {
        super.didAppear()
        
        animateWithDuration(kAnimationDuration, animations: { () -> Void in
            self.image.setTintColor(UIColor(red: 197 / 255.0, green: 68 / 255.0, blue: 245 / 255.0, alpha: 1.0))
            
            }) { () -> Void in
                self.animateWithDuration(self.kAnimationDuration) { () -> Void in
                    self.image.setTintColor(UIColor(red: 1, green: 17 / 255.0, blue: 79 / 255.0, alpha: 1.0))
                }
        }
    }
    
}

//
// see: http://stackoverflow.com/questions/30824275/animatewithduration-lacks-completion-block-watchos-2
//
extension WKInterfaceController {
    func animateWithDuration(duration: NSTimeInterval, animations: () -> Void, completion: (() -> Void)?) {
        animateWithDuration(duration, animations: animations)
        let completionDelay = dispatch_time(DISPATCH_TIME_NOW, Int64(duration * Double(NSEC_PER_SEC)))
        dispatch_after(completionDelay, dispatch_get_main_queue()) {
            completion?()
        }
    }
}

class HeartRelocationInterfaceController: WKInterfaceController {
    
    @IBOutlet var image: WKInterfaceImage!
    
    let kAnimationDuration : NSTimeInterval = 1

    @IBAction func upButtonTapped(sender: WKInterfaceButton) {
        animateWithDuration(self.kAnimationDuration) { () -> Void in
            self.image.setVerticalAlignment(.Top)
        }    
    }
    
    @IBAction func downButtonTapped(sender: WKInterfaceButton) {
        animateWithDuration(self.kAnimationDuration) { () -> Void in
            self.image.setVerticalAlignment(.Bottom)
        }
    }
    
}
