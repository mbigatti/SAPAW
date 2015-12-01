//
//  WorkoutHistoryInterfaceController.swift
//  FitnessApp
//
//  Created by Massimiliano Bigatti on 22/07/15.
//  Copyright © 2015 Massimiliano Bigatti. All rights reserved.
//

import WatchKit
import Foundation
import HealthKit

class WorkoutHistoryInterfaceController : WKInterfaceController {
    @IBOutlet var table: WKInterfaceTable!
    
    let healthStore = HKHealthStore()
    var workouts : [HKWorkout]?
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        let predicate = HKQuery.predicateForObjectsFromSource(HKSource.defaultSource())
        let sortDescriptor = NSSortDescriptor(key:HKSampleSortIdentifierStartDate, ascending: false)
        
        let query = HKSampleQuery(sampleType: HKWorkoutType.workoutType(), predicate: predicate, limit: Int(HKObjectQueryNoLimit), sortDescriptors: [sortDescriptor])
            { (sampleQuery: HKSampleQuery, samples: [HKSample]?, error: NSError? ) -> Void in
                
                dispatch_async(dispatch_get_main_queue(), {
                    if error == nil {
                        print("query performed \(samples?.count)")
                        let samplesCount = samples?.count ?? 0
                        
                        if samplesCount != 0 {
                            self.table.setNumberOfRows(samplesCount, withRowType: "WorkoutRow")
                            
                            if let _samples = samples as! [HKWorkout]? {
                                self.workouts = _samples
                                
                                for var index = 0; index < _samples.count; index++ {
                                    let workout = _samples[index]
                                    let rowController = self.table.rowControllerAtIndex(index) as! WorkoutRowController
                                    
                                    if let distanceInKM = workout.totalDistance?.doubleValueForUnit(HKUnit.meterUnitWithMetricPrefix(HKMetricPrefix.Kilo)) {

                                        rowController.setDistance(distanceInKM)
                                    }
                                    
                                    rowController.setDate(workout.startDate)
                                }
                            }
                            
                        } else {
                            self.table.setNumberOfRows(1, withRowType: "EmptyRow")
                            
                        }
                        
                    } else {
                        print("Error reading workouts \(error)")
                    }
                })
        }
        
        healthStore.executeQuery(query)
    }    

    override func contextForSegueWithIdentifier(segueIdentifier: String, inTable table: WKInterfaceTable, rowIndex: Int) -> AnyObject? {
        return workouts?[rowIndex]
    }
    
}