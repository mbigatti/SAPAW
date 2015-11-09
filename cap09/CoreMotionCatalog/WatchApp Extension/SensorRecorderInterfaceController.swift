//
//  SensorRecorderInterfaceController.swift
//  CoreMotionCatalog
//
//  Created by Massimiliano Bigatti on 20/10/15.
//  Copyright © 2015 Massimiliano Bigatti. All rights reserved.
//

import Foundation
import WatchKit
import CoreMotion

class SensorRecorderInterfaceController : WKInterfaceController {
    
    @IBOutlet var recordButton : WKInterfaceButton!
    @IBOutlet var statusLabel : WKInterfaceLabel!
    
    @IBOutlet var groupPositiveX: WKInterfaceGroup!
    @IBOutlet var groupPositiveY: WKInterfaceGroup!
    @IBOutlet var groupPositiveZ: WKInterfaceGroup!
    
    @IBOutlet var groupNegativeX: WKInterfaceGroup!
    @IBOutlet var groupNegativeY: WKInterfaceGroup!
    @IBOutlet var groupNegativeZ: WKInterfaceGroup!
    
    let kRecordDuration : NSTimeInterval = 3
    let sensorRecoder = CMSensorRecorder()
    var startDate : NSDate?
    
    
    //
    // MARK: - WKInterfaceController
    //

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        statusLabel.setText("Pronto a registrare per \(kRecordDuration) secondi")
    
        let groups = [groupPositiveX, groupPositiveY, groupPositiveZ, groupNegativeX, groupNegativeY, groupNegativeZ]
        for group in groups {
            group.setRelativeHeight(0, withAdjustment: 0)
        }
    }
    
    @IBAction func record() {
        startDate = NSDate()
        
        recordButton.setEnabled(false)
        statusLabel.setText("Registro... \(startDate!)")
        
        sensorRecoder.recordAccelerometerForDuration(kRecordDuration)
        
        NSTimer.scheduledTimerWithTimeInterval(kRecordDuration, target: self, selector: "recordingTimerFired:", userInfo: nil, repeats: false)
    }
    
    
    //
    // MARK: - Timers
    //
    
    func recordingTimerFired(timer: NSTimer) {
        recordButton.setEnabled(true)
        statusLabel.setText("Registrazione terminata")
        
        updateUI()
    }
    

    //
    // MARK: - Privates
    //
    
    private func updateUI() {
        let recorder = CMSensorRecorder()
        let now = NSDate()
        
        if let sensorData: CMSensorDataList = recorder.accelerometerDataFromDate(startDate!, toDate: now) {
            statusLabel.setText("Animazione...")
            
            let singleFrameDuration = Int64(1.0 / 50 * Double(NSEC_PER_SEC))
            var currentDelay : Int64 = 0
            
            for (_, data) in sensorData.enumerate() {
                if let _data = data as? CMRecordedAccelerometerData {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, currentDelay), dispatch_get_main_queue()) {
                        self.updateAxis(self.groupPositiveX, negativeGroup: self.groupNegativeX, force: _data.acceleration.x)
                        self.updateAxis(self.groupPositiveY, negativeGroup: self.groupNegativeY, force: _data.acceleration.y)
                        self.updateAxis(self.groupPositiveZ, negativeGroup: self.groupNegativeZ, force: _data.acceleration.z)

                    }
                    currentDelay += singleFrameDuration
                }
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, currentDelay), dispatch_get_main_queue()) {
                self.statusLabel.setText("Fine animazione")
            }
            
        } else {
            statusLabel.setText("Nessun dato registrato (da \(startDate!) a \(now))")
        }
    }
    
    private func updateAxis(positiveGroup: WKInterfaceGroup, negativeGroup: WKInterfaceGroup, force: Double) {
        if force < 0 {
            positiveGroup.setRelativeHeight(0, withAdjustment: 0)
            negativeGroup.setRelativeHeight(CGFloat(-force), withAdjustment: 0)
        } else {
            positiveGroup.setRelativeHeight(CGFloat(force), withAdjustment: 0)
            negativeGroup.setRelativeHeight(0, withAdjustment: 0)
        }
    }
}


// @see: http://stackoverflow.com/questions/31101573/swift-watchos-2-cmsensordatalist
extension CMSensorDataList: SequenceType {
    public func generate() -> NSFastGenerator {
        return NSFastGenerator(self)
    }
}