//
//  NewWorkoutInterfaceController.swift
//  FitnessApp
//
//  Created by Massimiliano Bigatti on 22/07/15.
//  Copyright © 2015 Massimiliano Bigatti. All rights reserved.
//

import WatchKit
import Foundation
import HealthKit


class NewWorkoutInterfaceController: WKInterfaceController {
    @IBOutlet var levelHeightGroup: WKInterfaceGroup!
    @IBOutlet var button: WKInterfaceButton!
    @IBOutlet var elapsedTimer: WKInterfaceTimer!
    @IBOutlet var heartRateLabel: WKInterfaceLabel!
    @IBOutlet var heartImage: WKInterfaceImage!
    @IBOutlet var distanceLabel: WKInterfaceLabel!
    @IBOutlet var energyLabel: WKInterfaceLabel!
    
    let healthStore = HKHealthStore()
    
    typealias anchoredQueryHandler = ((HKAnchoredObjectQuery, [HKSample]?, [HKDeletedObject]?, HKQueryAnchor?, NSError?) -> Void)
    
    var running = false

    // distance data
    var distance : Double = 0
    var distanceQuery : HKQuery?
    var distanceSamples = [HKQuantitySample]()
    var distanceAnchor : HKQueryAnchor?
    let distanceUnit = HKUnit.meterUnitWithMetricPrefix(HKMetricPrefix.Kilo)

    // heart data
    let heartRateRanges = HeartRateRanges()
    var heartRateQuery : HKQuery?
    var heartRateSamples = [HKQuantitySample]()
    var heartRateAnchor : HKQueryAnchor?
    let heartRateUnit = HKUnit(fromString: "count/min")
    
    // energy data
    var energy : Double = 0    
    var energyQuery : HKQuery?
    var energySamples = [HKQuantitySample]()
    var energyAnchor : HKQueryAnchor?
    let energyUnit = HKUnit.kilocalorieUnit()    
    
    // session data
    let workoutSession = HKWorkoutSession(
        activityType: HKWorkoutActivityType.Cycling,
        locationType: HKWorkoutSessionLocationType.Outdoor)
    var startDate: NSDate?
    var endDate: NSDate?

    // formatters
    let distanceFormatter = NSLengthFormatter()
    let energyFormatter = NSEnergyFormatter()


    // MARK: - Actions
    
    @IBAction func buttonTapped() {
        if running {
            let stopAction = WKAlertAction(title: "Interrompi", style: .Default) {
                self.stopWorkout()
            }
            let continueAction = WKAlertAction(title: "Prosegui", style: .Default) {}
            
            self.presentAlertControllerWithTitle("Fitness App", message: "Vuoi interrompere l'allenamento?", preferredStyle: .SideBySideButtonsAlert, actions: [stopAction, continueAction])
            
        } else {
            startWorkout()
        }        
    }
        
}
