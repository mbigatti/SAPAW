//
//  InterfaceController.swift
//  WatchApp Extension
//
//  Created by Massimiliano Bigatti on 29/06/15.
//  Copyright © 2015 Massimiliano Bigatti. All rights reserved.
//

import WatchKit
import Foundation
import HealthKit


class InterfaceController: WKInterfaceController {    
    let healthStore = HKHealthStore()
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        if HKHealthStore.isHealthDataAvailable() {
            print("requesting HealthKit authorization")
            
            healthStore.requestAuthorizationToShareTypes(shareDataTypes(), readTypes: readDataTypes()) { (success, error) -> Void in
                if error == nil {
                    if success {
                        print("access to health data authorized")
                        
                    } else {
                        print("not authorized to access health data")
                        
                        self.presentAlertWithMessage("Per utilizzare l'applicazione consentire l'acceso ai dati medici.")
                    }
                    
                } else {
                    print("error requesting authorization \(error)")
                }
            }
            
        } else {
            self.presentAlertWithMessage("HealthKit non disponibile. Impossibile procedere.")
            
        }        
    }
    

    // MARK: - Privates
    
    private func shareDataTypes() -> Set<HKSampleType>? {
        return NSSet(array: [
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierActiveEnergyBurned)!,
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDistanceCycling)!,
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeartRate)!,
            HKQuantityType.workoutType()
            
            ]) as? Set<HKSampleType>
    }
    
    private func readDataTypes() -> Set<HKObjectType>? {
        return NSSet(array: [
            HKQuantityType.workoutType(),
            HKQuantityType.characteristicTypeForIdentifier(HKCharacteristicTypeIdentifierDateOfBirth)!,
            HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeartRate)!,
            HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDistanceCycling)!,
            HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierActiveEnergyBurned)!
            
            ]) as? Set<HKObjectType>
    }
    
}