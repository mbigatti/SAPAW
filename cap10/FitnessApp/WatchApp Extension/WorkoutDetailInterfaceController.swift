//
//  WorkoutDetailInterfaceController.swift
//  FitnessApp
//
//  Created by Massimiliano Bigatti on 23/07/15.
//  Copyright © 2015 Massimiliano Bigatti. All rights reserved.
//

import Foundation
import WatchKit
import HealthKit

class WorkoutDetailInterfaceController : WKInterfaceController {
    @IBOutlet var dateLabel: WKInterfaceLabel!
    @IBOutlet var durationLabel: WKInterfaceLabel!
    @IBOutlet var distanceLabel: WKInterfaceLabel!
    @IBOutlet var energyLabel: WKInterfaceLabel!

    
    // MARK: Formatters
    
    lazy var dateFormatter: NSDateFormatter = {
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "dd/MM/yyyy hh:mm:ss"
        return formatter;
        
    }()
    
    let durationFormatter = NSDateComponentsFormatter()
    let distanceFormatter = NSLengthFormatter()
    let energyFormatter = NSEnergyFormatter()
    
    
    // MARK: - WKInterfaceController
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)

        let workout = context as! HKWorkout
        
        dateLabel.setText(dateFormatter.stringFromDate(workout.startDate))
        durationLabel.setText(durationFormatter.stringFromTimeInterval(workout.duration))
        
        if let distanceInKM = workout.totalDistance?.doubleValueForUnit(HKUnit.meterUnitWithMetricPrefix(HKMetricPrefix.Kilo)) {            
            distanceLabel.setText(distanceFormatter.stringFromValue(distanceInKM, unit: .Kilometer))
        }
        
        if let energyBurned = workout.totalEnergyBurned?.doubleValueForUnit(HKUnit.kilocalorieUnit()) {
            energyLabel.setText(energyFormatter.stringFromJoules(energyBurned))
        }
    }
}