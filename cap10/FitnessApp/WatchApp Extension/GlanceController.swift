//
//  GlanceController.swift
//  WatchApp Extension
//
//  Created by Massimiliano Bigatti on 29/06/15.
//  Copyright © 2015 Massimiliano Bigatti. All rights reserved.
//

import WatchKit
import Foundation
import HealthKit

class GlanceController: WKInterfaceController {
    @IBOutlet var dailyDistanceLabel: WKInterfaceLabel!
    @IBOutlet var dailyEnergyLabel: WKInterfaceLabel!
    
    let healthStore = HKHealthStore()
    
    let distanceFormatter = NSLengthFormatter()
    let energyFormatter = NSEnergyFormatter()
    
    var dailyDistanceLabelUpdated = false
    var dailyEnergyLabelUpdated = false

    typealias CompletionHandler = (quantity: HKQuantity?) -> Void
    
    override func willActivate() {
        super.willActivate()
        
        beginGlanceUpdates()
        
        dailyDistanceLabelUpdated = false
        dailyEnergyLabelUpdated = false
        
        //
        // query distance
        //
        let distanceSampleType = HKQuantityType.quantityTypeForIdentifier(
            HKQuantityTypeIdentifierDistanceCycling)!
        
        dailyQuantityForSampleType(distanceSampleType) { (quantity) -> Void in
            if let _quantity = quantity {
                let unit = HKUnit.meterUnitWithMetricPrefix(HKMetricPrefix.Kilo)
                let totalDistance = _quantity.doubleValueForUnit(unit)
                self.dailyDistanceLabel.setText(self.distanceFormatter.stringFromValue(totalDistance, unit: .Kilometer))
                self.dailyDistanceLabelUpdated = true
                self.endGlanceUpdatesIfRequired()
            }
        }
        
        //
        // query energy
        //
        let energySampleType = HKQuantityType.quantityTypeForIdentifier(
            HKQuantityTypeIdentifierActiveEnergyBurned)!
        
        dailyQuantityForSampleType(energySampleType) { (quantity) -> Void in
            if let _quantity = quantity {
                let unit = HKUnit.kilocalorieUnit()
                let totalCalories = _quantity.doubleValueForUnit(unit)
                self.dailyEnergyLabel.setText(self.energyFormatter.stringFromJoules(totalCalories))
                self.dailyEnergyLabelUpdated = true
                self.endGlanceUpdatesIfRequired()
            }
        }
    }
    
    func endGlanceUpdatesIfRequired() {
        if dailyDistanceLabelUpdated && dailyEnergyLabelUpdated {
            endGlanceUpdates()
        }
    }
    
    func dailyQuantityForSampleType(sampleType: HKQuantityType, completionHandler: CompletionHandler) {
        let calendar = NSCalendar.currentCalendar()
        let now = NSDate()
        let components = calendar.components([.Year, .Month, .Day], fromDate: now)
        
        let startDate = calendar.dateFromComponents(components)!
        
        let endDate = calendar.dateByAddingUnit(NSCalendarUnit.Day,
            value: 1, toDate: startDate, options: NSCalendarOptions())!
        
        let predicate = HKQuery.predicateForSamplesWithStartDate(startDate,
            endDate: endDate, options: .StrictStartDate)
        
        let query = HKStatisticsQuery(quantityType: sampleType,
            quantitySamplePredicate: predicate,
            options: .CumulativeSum) { query, result, error in
                
                dispatch_async(dispatch_get_main_queue(), {
                    if error == nil {
                        if let quantity = result!.sumQuantity() {
                            completionHandler(quantity: quantity)
                        }
                    } else {
                        print("Error while gathering statistics \(error)")
                        completionHandler(quantity: nil)
                    }
                })
        }
        
        healthStore.executeQuery(query)
    }

}
