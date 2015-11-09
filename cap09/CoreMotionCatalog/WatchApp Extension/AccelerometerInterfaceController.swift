//
//  AccelerometerInterfaceController.swift
//  CoreMotionCatalog
//
//  Created by Massimiliano Bigatti on 21/10/15.
//  Copyright © 2015 Massimiliano Bigatti. All rights reserved.
//

import Foundation
import WatchKit
import CoreMotion

// @see https://www.bignerdranch.com/blog/watchkit-2-hardware-bits-the-accelerometer/

class AccelerometerInterfaceController : WKInterfaceController {
    @IBOutlet var updateGroup: WKInterfaceGroup!
    @IBOutlet var errorLabel: WKInterfaceLabel!

    @IBOutlet var groupPositiveX: WKInterfaceGroup!
    @IBOutlet var groupPositiveY: WKInterfaceGroup!
    @IBOutlet var groupPositiveZ: WKInterfaceGroup!
    
    @IBOutlet var groupNegativeX: WKInterfaceGroup!
    @IBOutlet var groupNegativeY: WKInterfaceGroup!
    @IBOutlet var groupNegativeZ: WKInterfaceGroup!

    @IBOutlet var labelX: WKInterfaceLabel!    
    @IBOutlet var labelY: WKInterfaceLabel!
    @IBOutlet var labelZ: WKInterfaceLabel!
    
    let kUpdateInterval : NSTimeInterval = 0.5
    let numberFormatter = NSNumberFormatter()
    
    let motionManager = CMMotionManager()
    
    
    //
    // MARK: - WKInterfaceController
    //
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // @see: http://www.unicode.org/reports/tr35/tr35-31/tr35-numbers.html#Number_Format_Patterns
        numberFormatter.positiveFormat = "#.###"
        
        updateGroup.setAlpha(0)
        errorLabel.setText("")
        
        let groups = [groupPositiveX, groupPositiveY, groupPositiveZ, groupNegativeX, groupNegativeY, groupNegativeZ]
        for group in groups {
            group.setRelativeHeight(0, withAdjustment: 0)
        }
        
        labelX.setText("")
        labelY.setText("")
        labelZ.setText("")
        
        motionManager.accelerometerUpdateInterval = kUpdateInterval
    }
    
    override func willActivate() {
        super.willActivate()
        
        motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.mainQueue()) { (data: CMAccelerometerData?, error: NSError?) -> Void in
            if let _error = error {
                self.errorLabel.setText(_error.localizedDescription)
            }
            
            if let _data = data {
                self.updateGroup.setAlpha(1)
                self.animateWithDuration(self.kUpdateInterval / Double(2), animations: { () -> Void in
                    self.updateGroup.setAlpha(0)
                })
                
                self.updateAxis(self.groupPositiveX, negativeGroup: self.groupNegativeX, label: self.labelX, force: _data.acceleration.x)
                self.updateAxis(self.groupPositiveY, negativeGroup: self.groupNegativeY, label: self.labelY,force: _data.acceleration.y)
                self.updateAxis(self.groupPositiveZ, negativeGroup: self.groupNegativeZ, label: self.labelZ,force: _data.acceleration.z)
            }
        }
    }
    
    override func didDeactivate() {
        super.didDeactivate()
        
        motionManager.stopAccelerometerUpdates()
    }
    
    
    //
    // MARK: - Privates
    //
    
    private func updateAxis(positiveGroup: WKInterfaceGroup, negativeGroup: WKInterfaceGroup, label: WKInterfaceLabel, force: Double) {
        label.setText(numberFormatter.stringFromNumber(NSNumber(double: force)))
        
        if force < 0 {
            positiveGroup.setRelativeHeight(0, withAdjustment: 0)
            negativeGroup.setRelativeHeight(CGFloat(-force), withAdjustment: 0)
        } else {
            positiveGroup.setRelativeHeight(CGFloat(force), withAdjustment: 0)
            negativeGroup.setRelativeHeight(0, withAdjustment: 0)
        }
    }
    
}