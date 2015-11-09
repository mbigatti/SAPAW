//
//  PedometerInterfaceController.swift
//  CoreMotionCatalog
//
//  Created by Massimiliano Bigatti on 20/10/15.
//  Copyright © 2015 Massimiliano Bigatti. All rights reserved.
//

import Foundation
import WatchKit
import CoreMotion

class PedometerInterfaceController : WKInterfaceController {
    
    @IBOutlet var startDateLabel: WKInterfaceLabel!
    @IBOutlet var endDateLabel: WKInterfaceLabel!
    @IBOutlet var stepsLabel: WKInterfaceLabel!
    @IBOutlet var distanceLabel: WKInterfaceLabel!
    @IBOutlet var paceLabel: WKInterfaceLabel!
    @IBOutlet var cadenceLabel: WKInterfaceLabel!
    @IBOutlet var startButton: WKInterfaceButton!
    @IBOutlet var stopButton: WKInterfaceButton!
    @IBOutlet var errorLabel: WKInterfaceLabel!
    
    let pedometer = CMPedometer()
    
    let dateFormatter = NSDateFormatter()
    let numberFormatter = NSNumberFormatter()
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        dateFormatter.dateFormat = "hh:mm:ss"
        numberFormatter.positiveFormat = "#,###.##"
        
        stopButton.setEnabled(false)
    }
    
    @IBAction func startButtonTapped() {
        self.errorLabel.setText("")
        
        pedometer.startPedometerUpdatesFromDate(NSDate()) { (data: CMPedometerData?, error: NSError?) -> Void in
            
            if let _error = error {
                self.errorLabel.setText(_error.localizedDescription)
                self.updateUI(false)
            }
            
            if let _data = data {
                self.startDateLabel.setAlpha(0)
                self.endDateLabel.setAlpha(0)
                
                self.startDateLabel.setText(self.dateFormatter.stringFromDate(_data.startDate))
                self.endDateLabel.setText(self.dateFormatter.stringFromDate(_data.endDate))
                
                self.animateWithDuration(0.25, animations: { () -> Void in
                    self.startDateLabel.setAlpha(1.0)
                    self.endDateLabel.setAlpha(1.0)
                })
                
                self.stepsLabel.setText(self.numberFormatter.stringFromNumber(_data.numberOfSteps))
                
                if let distance = _data.distance {
                    self.distanceLabel.setText(self.numberFormatter.stringFromNumber(distance))
                } else {
                    self.distanceLabel.setText("--")
                }
                
                if let pace = _data.currentPace {
                    self.paceLabel.setText(self.numberFormatter.stringFromNumber(pace))
                } else {
                    self.paceLabel.setText("--")
                }
                
                if let cadence = _data.currentCadence {
                    self.cadenceLabel.setText(self.numberFormatter.stringFromNumber(cadence))
                } else {
                    self.cadenceLabel.setText("--")
                }
            }
        }
        
        updateUI(true)
    }
    
    @IBAction func stopButtonTapped() {
        pedometer.stopPedometerUpdates()
        updateUI(false)
    }
    
    private func updateUI(running: Bool) {
        startButton.setEnabled(!running)
        stopButton.setEnabled(running)
    }

}