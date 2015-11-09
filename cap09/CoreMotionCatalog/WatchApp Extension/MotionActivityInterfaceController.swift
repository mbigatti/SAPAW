//
//  MotionActivityInterfaceController.swift
//  CoreMotionCatalog
//
//  Created by Massimiliano Bigatti on 20/10/15.
//  Copyright © 2015 Massimiliano Bigatti. All rights reserved.
//

import Foundation
import WatchKit
import CoreMotion

class MotionActivityInterfaceController : WKInterfaceController {
    
    @IBOutlet var currentActivityDescriptionLabel: WKInterfaceLabel!
    @IBOutlet var currentActivityStartDateLabel: WKInterfaceLabel!
    @IBOutlet var currentActivityConfidenceLabel: WKInterfaceLabel!
    
    @IBOutlet var previousActivityTitleLabel: WKInterfaceLabel!
    @IBOutlet var previousActivityStartDateLabel: WKInterfaceLabel!
    @IBOutlet var previousActivityEndDateLabel: WKInterfaceLabel!
    
    @IBOutlet var errorLabel: WKInterfaceLabel!
    
    let motionActivityManager = CMMotionActivityManager()
    let queue = NSOperationQueue.mainQueue()
    
    let hourFormatter = NSDateFormatter()
    let dateFormatter = NSDateFormatter()
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        hourFormatter.dateFormat = "hh:mm:ss"
        dateFormatter.dateFormat = "dd/MM hh:mm"
        
        motionActivityManager.startActivityUpdatesToQueue(queue) { (activity: CMMotionActivity?) -> Void in            
            if let _activity = activity {
                if let description = self.stringFromActivity(_activity) {
                    self.currentActivityDescriptionLabel.setText(description)
                } else {
                    self.currentActivityDescriptionLabel.setText("--")
                }
                self.currentActivityStartDateLabel.setText(self.hourFormatter.stringFromDate(_activity.startDate))
                self.currentActivityConfidenceLabel.setText("Conf. \(self.stringFromConfidence(_activity.confidence))")
            }
        }
        
        motionActivityManager.queryActivityStartingFromDate(NSDate.yesterday(), toDate: NSDate(), toQueue: queue) { (activities: [CMMotionActivity]?, error: NSError?) -> Void in
            
            if let _error = error {
                self.errorLabel.setText(_error.localizedDescription)
            } else {
                self.errorLabel.setText("")
            }
            
            if let _activities = activities {
                self.previousActivityTitleLabel.setText("Ci sono \(_activities.count) rilevazioni attività nel giorno precedente comprese tra le due date seguenti:")
                
                if let startDate = _activities.first?.startDate {
                    self.previousActivityStartDateLabel.setText(self.dateFormatter.stringFromDate(startDate))
                } else {
                    self.previousActivityStartDateLabel.setText("--")
                }
                
                if let endDate = _activities.last?.startDate {
                    self.previousActivityEndDateLabel.setText(self.dateFormatter.stringFromDate(endDate))
                } else {
                    self.previousActivityEndDateLabel.setText("--")
                }
            }
        }
    }
    
    private func stringFromActivity(activity: CMMotionActivity) -> String? {
        if activity.stationary {
            return "Stazionario"
        }
        if activity.walking {
            return "In cammino"
        }
        if activity.running {
            return "In corsa"
        }
        if activity.automotive {
            return "Su mezzo di trasporto"
        }
        if activity.cycling {
            return "In bicicletta"
        }
        if activity.unknown {
            return "Attività ignota"
        }
        return nil
    }
    
    private func stringFromConfidence(confidence: CMMotionActivityConfidence) -> String {
        switch confidence {
        case .High: return "alta"
        case .Medium: return "media"
        case .Low: return "bassa"
        }
    }
    
}