//
//  WorkoutRowController.swift
//  UICatalog
//
//  Created by Massimiliano Bigatti on 23/06/15.
//  Copyright © 2015 Massimiliano Bigatti. All rights reserved.
//

import WatchKit
import HealthKit

class WorkoutRowController : NSObject {

    @IBOutlet var distanceLabel: WKInterfaceLabel!
    @IBOutlet var dateLabel: WKInterfaceLabel!
    
    let distanceFormatter = NSLengthFormatter()    
    lazy var dateFormatter: NSDateFormatter = {
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "dd/MM hh:mm"
        return formatter;
        
        }()
    
    
    func setDistance(distance: Double) {
        distanceLabel.setText(distanceFormatter.stringFromValue(distance, unit: .Kilometer))
    }
    
    func setDate(date: NSDate) {
        dateLabel.setText(dateFormatter.stringFromDate(date))
    }
    
}