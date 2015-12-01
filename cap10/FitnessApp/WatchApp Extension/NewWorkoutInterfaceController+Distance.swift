//
//  NewWorkoutInterfaceController+Distance.swift
//  FitnessApp
//
//  Created by Massimiliano Bigatti on 30/11/15.
//  Copyright © 2015 Massimiliano Bigatti. All rights reserved.
//

import Foundation
import WatchKit
import HealthKit

extension NewWorkoutInterfaceController {
    
    func setupDistanceQuery() {
        distanceQuery = createDistanceStreamingQueryFromDate(NSDate(), completionHandler: { (query: HKAnchoredObjectQuery, samples: [HKSample]?, deleted: [HKDeletedObject]?, newAnchor: HKQueryAnchor?, error: NSError?) -> Void in
            
            if error == nil {
                self.distanceAnchor = newAnchor
                self.saveDistanceSamples(samples)
                
            } else {
                print("error while initializing distance streaming \(error)")
            }
            
            }) { (query: HKAnchoredObjectQuery, samples: [HKSample]?, deleted: [HKDeletedObject]?, newAnchor: HKQueryAnchor?, error: NSError?) -> Void in
                if error == nil {
                    self.distanceAnchor = newAnchor
                    self.saveDistanceSamples(samples)
                    
                } else {
                    print("error while streaming distance \(error)")
                }
        }
        
        healthStore.executeQuery(distanceQuery!)
    }
    
    func createDistanceStreamingQueryFromDate(workoutStartDate: NSDate, completionHandler: anchoredQueryHandler, updateHandler: anchoredQueryHandler) -> HKQuery {
        
        let sampleType = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDistanceCycling)!
        let predicate = HKQuery.predicateForSamplesWithStartDate(startDate, endDate: nil, options: .None)
        
        let query = HKAnchoredObjectQuery(type: sampleType, predicate: predicate, anchor: distanceAnchor, limit: Int(HKObjectQueryNoLimit)) { (query: HKAnchoredObjectQuery, samples: [HKSample]?, deleted: [HKDeletedObject]?, newAnchor: HKQueryAnchor?, error: NSError?) -> Void in
            
            self.distanceAnchor = newAnchor!
            completionHandler(query, samples, nil, newAnchor!, error)
        }
        
        query.updateHandler = updateHandler
        
        return query
    }
    
    func saveDistanceSamples(samples: [HKSample]?) {
        guard let _samples = samples as?[HKQuantitySample] where _samples.count > 0 else { return }
        distanceSamples += _samples
        
        for sample in _samples {
            distance += sample.quantity.doubleValueForUnit(distanceUnit)
            print("distance \(distance)")
        }
        
        dispatch_async(dispatch_get_main_queue()) {
            self.distanceLabel.setText(self.distanceFormatter.stringFromValue(self.distance, unit: .Kilometer))
        }
    }
   
}