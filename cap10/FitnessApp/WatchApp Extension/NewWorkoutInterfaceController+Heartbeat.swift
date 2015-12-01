//
//  NewWorkoutInterfaceController+Heartbeat.swift
//  FitnessApp
//
//  Created by Massimiliano Bigatti on 30/07/15.
//  Copyright © 2015 Massimiliano Bigatti. All rights reserved.
//

import Foundation
import WatchKit
import HealthKit

extension NewWorkoutInterfaceController {
    
    // MARK: - Heartbeat Management
    
    func setupHeartRateQuery() {
        heartRateLabel.setText("Misuro")
        
        heartRateQuery = createHeartRateStreamingQueryFromDate(NSDate(), completionHandler: { (query: HKAnchoredObjectQuery, samples: [HKSample]?, deleted: [HKDeletedObject]?, newAnchor: HKQueryAnchor?, error: NSError?) -> Void in
            
            if error == nil {
                self.heartRateAnchor = newAnchor
                self.saveHeartRateSamples(samples)
                
            } else {
                print("error while initializing heartbeat streaming \(error)")
            }
            
            }) { (query: HKAnchoredObjectQuery, samples: [HKSample]?, deleted: [HKDeletedObject]?, newAnchor: HKQueryAnchor?, error: NSError?) -> Void in
                if error == nil {
                    self.heartRateAnchor = newAnchor
                    self.saveHeartRateSamples(samples)
                    
                } else {
                    print("error while streaming heartbeat \(error)")
                }
        }
        
        healthStore.executeQuery(heartRateQuery!)
    }
    
    func saveHeartRateSamples(samples: [HKSample]?) {
        guard let _samples = samples as?[HKQuantitySample] where _samples.count > 0 else { return }
        heartRateSamples += _samples
        
        updateHeartRateWithSamples(_samples)
    }
    
    func createHeartRateStreamingQueryFromDate(workoutStartDate: NSDate, completionHandler: anchoredQueryHandler, updateHandler: anchoredQueryHandler) -> HKQuery {
        let sampleType = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeartRate)
        
        let query = HKAnchoredObjectQuery(type: sampleType!, predicate: nil, anchor: heartRateAnchor, limit: Int(HKObjectQueryNoLimit)) { (query: HKAnchoredObjectQuery, samples: [HKSample]?, deleted: [HKDeletedObject]?, newAnchor: HKQueryAnchor?, error: NSError?) -> Void in

            self.heartRateAnchor = newAnchor!
            completionHandler(query, samples, nil, newAnchor!, error)
        }
        
        query.updateHandler = updateHandler
        
        return query
    }
    
    func updateHeartRateWithSamples(samples: [HKQuantitySample]) {
        dispatch_async(dispatch_get_main_queue()) {
            if let heartRateValue = samples.first?.quantity.doubleValueForUnit(self.heartRateUnit) {
                let percFmax = self.heartRateRanges.percentage(heartRateValue)
                print("heartRateValue=\(heartRateValue) percFmax=\(percFmax)")
                
                let format = "3.0"
                self.heartRateLabel.setText("\(heartRateValue.format(format))")
                
                let height = CGFloat(percFmax - 0.5)
                self.levelHeightGroup.setRelativeHeight(height, withAdjustment: 0)
            }
            self.pulseHeart()
        }
    }
    
    func pulseHeart() {
        let kDuration1 = 0.15
        let kDuration2 = 0.2
        let widths : [CGFloat] = [18, 16]
        let heights : [CGFloat] = [18, 16]
        
        self.animateWithDuration(kDuration1, animations: { () -> Void in
            self.heartImage.setWidth(widths[0])
            self.heartImage.setHeight(heights[0])
            
            }) { () -> Void in
                self.animateWithDuration(kDuration2, animations: { () -> Void in
                    self.heartImage.setWidth(widths[1])
                    self.heartImage.setHeight(heights[1])
                })
        }
    }
    
}


//
// see: http://stackoverflow.com/questions/30824275/animatewithduration-lacks-completion-block-watchos-2
//
extension WKInterfaceController {
    func animateWithDuration(duration: NSTimeInterval, animations: () -> Void, completion: (() -> Void)?) {
        animateWithDuration(duration, animations: animations)
        let completionDelay = dispatch_time(DISPATCH_TIME_NOW, Int64(duration * Double(NSEC_PER_SEC)))
        dispatch_after(completionDelay, dispatch_get_main_queue()) {
            completion?()
        }
    }
}

extension Double {
    func format(format: String) -> String {
        return String(format: "%\(format)f", self)
    }
}
