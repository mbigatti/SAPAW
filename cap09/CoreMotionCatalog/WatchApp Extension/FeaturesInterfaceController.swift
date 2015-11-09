//
//  FeaturesInterfaceController.swift
//  CoreMotionCatalog
//
//  Created by Massimiliano Bigatti on 20/10/15.
//  Copyright © 2015 Massimiliano Bigatti. All rights reserved.
//

import Foundation
import WatchKit
import CoreMotion

class FeaturesInterfaceController : WKInterfaceController {

    @IBOutlet var table: WKInterfaceTable!
    
    override func awakeWithContext(context: AnyObject?) {
        
        table.setRowTypes([
            "TitleRow",
            "FeatureRow",
            
            "TitleRow",
            "FeatureRow",
            "FeatureRow",
            "FeatureRow",
            "FeatureRow",
            "FeatureRow",
            
            "TitleRow",
            "FeatureRow",
            
            "TitleRow",
            "FeatureRow",
            "FeatureRow",
            
            "TitleRow",
            "FeatureRow",
            "FeatureRow",
            "FeatureRow",
            "FeatureRow"
        ])

        var index = 0
        updateTitleAtIndex(index++, withTitle: "CMAltimeter")
        updateFeatureAtIndex(index++, withDescription: "Altimetro", availability: CMAltimeter.isRelativeAltitudeAvailable())
        
        updateTitleAtIndex(index++, withTitle: "CMPedometer")
        updateFeatureAtIndex(index++, withDescription: "Cadenza", availability: CMPedometer.isCadenceAvailable())
        updateFeatureAtIndex(index++, withDescription: "Distanza", availability: CMPedometer.isDistanceAvailable())
        updateFeatureAtIndex(index++, withDescription: "Conta piani", availability: CMPedometer.isFloorCountingAvailable())
        updateFeatureAtIndex(index++, withDescription: "Ritmo", availability: CMPedometer.isPaceAvailable())
        updateFeatureAtIndex(index++, withDescription: "Conta passi", availability: CMPedometer.isStepCountingAvailable())
        
        updateTitleAtIndex(index++, withTitle: "CMMotionActivityManager")
        updateFeatureAtIndex(index++, withDescription: "Attività Motoria", availability: CMMotionActivityManager.isActivityAvailable())
        
        updateTitleAtIndex(index++, withTitle: "CMSensorRecorder")
        updateFeatureAtIndex(index++, withDescription: "Registrazione accelerometro", availability: CMSensorRecorder.isAccelerometerRecordingAvailable())
        updateFeatureAtIndex(index++, withDescription: "Autorizzazione registrazione", availability: CMSensorRecorder.isAuthorizedForRecording())
        
        let motionManager = CMMotionManager()
        updateTitleAtIndex(index++, withTitle: "CMMotionManager")
        updateFeatureAtIndex(index++, withDescription: "Accelerometro", availability: motionManager.accelerometerAvailable)
        updateFeatureAtIndex(index++, withDescription: "Giroscopio", availability: motionManager.gyroAvailable)
        updateFeatureAtIndex(index++, withDescription: "Magnetometro", availability: motionManager.magnetometerAvailable)
        updateFeatureAtIndex(index++, withDescription: "Movimento del dispositivo", availability: motionManager.deviceMotionAvailable)
    }
    
    func updateTitleAtIndex(index: Int, withTitle title: String) {
        let rowController = table.rowControllerAtIndex(index) as! TitleRowController
        rowController.setTitle(title)
    }
    
    func updateFeatureAtIndex(index: Int, withDescription description: String, availability available: Bool) {
        let rowController = table.rowControllerAtIndex(index) as! FeatureRowController
        rowController.setDescription(description)
        rowController.setAvailable(available)
    }
}