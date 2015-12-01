//
//  NewWorkoutInterfaceController+Energy.swift
//  FitnessApp
//
//  Created by Massimiliano Bigatti on 30/11/15.
//  Copyright © 2015 Massimiliano Bigatti. All rights reserved.
//

import Foundation
import WatchKit
import HealthKit

extension NewWorkoutInterfaceController {
    
    func setupEnergyQuery() {
        energyQuery = createEnergyStreamingQueryFromDate(NSDate(), completionHandler: { (query: HKAnchoredObjectQuery, samples: [HKSample]?, deleted: [HKDeletedObject]?, newAnchor: HKQueryAnchor?, error: NSError?) -> Void in
            
            if error == nil {
                self.energyAnchor = newAnchor
                self.saveEnergySamples(samples)
                
            } else {
                print("error while initializing energy streaming \(error)")
            }
            
            }) { (query: HKAnchoredObjectQuery, samples: [HKSample]?, deleted: [HKDeletedObject]?, newAnchor: HKQueryAnchor?, error: NSError?) -> Void in
                if error == nil {
                    self.energyAnchor = newAnchor
                    self.saveEnergySamples(samples)
                    
                } else {
                    print("error while streaming energy \(error)")
                }
        }
        
        healthStore.executeQuery(energyQuery!)
    }
    
    func createEnergyStreamingQueryFromDate(workoutStartDate: NSDate, completionHandler: anchoredQueryHandler, updateHandler: anchoredQueryHandler) -> HKQuery {
        
        let sampleType = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierActiveEnergyBurned)!
        let predicate = HKQuery.predicateForSamplesWithStartDate(startDate, endDate: nil, options: .None)
        
        let query = HKAnchoredObjectQuery(type: sampleType, predicate: predicate, anchor: energyAnchor, limit: Int(HKObjectQueryNoLimit)) { (query: HKAnchoredObjectQuery, samples: [HKSample]?, deleted: [HKDeletedObject]?, newAnchor: HKQueryAnchor?, error: NSError?) -> Void in
            
            self.energyAnchor = newAnchor!
            completionHandler(query, samples, nil, newAnchor!, error)
        }
        
        query.updateHandler = updateHandler
        
        return query
    }
    
    func saveEnergySamples(samples: [HKSample]?) {
        guard let _samples = samples as?[HKQuantitySample] where _samples.count > 0 else { return }
        energySamples += _samples
        
        for sample in _samples {
            energy += sample.quantity.doubleValueForUnit(energyUnit)
            print("energy \(energy)")
        }
        
        dispatch_async(dispatch_get_main_queue()) {
            self.energyLabel.setText(self.energyFormatter.stringFromValue(self.energy, unit: .Kilocalorie))
        }
    }
    
}