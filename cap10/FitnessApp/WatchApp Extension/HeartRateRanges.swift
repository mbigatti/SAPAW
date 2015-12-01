//
//  HeartRateRanges.swift
//  FitnessApp
//
//  Created by Massimiliano Bigatti on 22/07/15.
//  Copyright © 2015 Massimiliano Bigatti. All rights reserved.
//

import Foundation
import HealthKit

class HeartRateRanges {

    var fcmax : Double?
    
    init() {
        do {
            let healthStore = HKHealthStore()
            let birthDay = try healthStore.dateOfBirth()
            let today = NSDate()
            let differenceComponents = NSCalendar.currentCalendar().components(.Year, fromDate: birthDay, toDate: today, options: NSCalendarOptions(rawValue: 0) )
            
            let age = differenceComponents.year
            
            // Calculate FC max using Tanaka formula
            fcmax = 208 - 0.7 * Double(age)
            
        } catch {
            print("Error reading birthday: \(error)")
            
            fcmax = 208 - 0.7 * 41
        }
    }
    
    func percentage(heartRate: Double) -> Double {
        return fcmax != nil ? heartRate / fcmax! : 0
    }

}