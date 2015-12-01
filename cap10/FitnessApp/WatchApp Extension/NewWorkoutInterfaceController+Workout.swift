//
//  NewWorkoutInterfaceController+Workout.swift
//  FitnessApp
//
//  Created by Massimiliano Bigatti on 30/07/15.
//  Copyright © 2015 Massimiliano Bigatti. All rights reserved.
//

import Foundation
import WatchKit
import HealthKit


extension NewWorkoutInterfaceController {
    
    // MARK: - Workflow Management
    
    func startWorkout() {
        print("startWorkout")
        
        button.setTitle("Stop")
        
        elapsedTimer.setDate(NSDate())
        elapsedTimer.start()
        
        startDate = NSDate()
        running = true
        
        healthStore.startWorkoutSession(self.workoutSession)
        
        setupDistanceQuery()
        setupEnergyQuery()
        setupHeartRateQuery()
    }
    
    func stopWorkout() {
        print("stopWorkout")
        
        button.setTitle("Avvia")
        
        endDate = NSDate()
        
        if distanceQuery != nil {
            healthStore.stopQuery(distanceQuery!)
        }
        if heartRateQuery != nil {
            healthStore.stopQuery(heartRateQuery!)
        }
        if energyQuery != nil {
            healthStore.stopQuery(energyQuery!)
        }
        
        healthStore.endWorkoutSession(self.workoutSession)
        
        saveWorkout()
        
        elapsedTimer.stop()
        
        running = false
        
        popController()
    }
    
    func saveWorkout() {
        print("saveWorkout")
        
        let distanceQuantity = HKQuantity(unit: distanceUnit, doubleValue: distance)
        let energyQuantity = HKQuantity(unit: energyUnit, doubleValue: energy)
        
        let workout = HKWorkout(
            activityType:       .Cycling,
            startDate:          startDate!,
            endDate:            endDate!,
            duration:           abs(endDate!.timeIntervalSinceDate(startDate!)),
            totalEnergyBurned:  energyQuantity,
            totalDistance:      distanceQuantity,
            metadata:           nil)
        
        healthStore.saveObject(workout) { (result: Bool, error: NSError?) -> Void in
            if error == nil {
                print("workout saved \(result)")
                
                var samples = [HKQuantitySample]()
                samples += self.distanceSamples
                samples += self.heartRateSamples
                samples += self.energySamples
                
                self.healthStore.addSamples(samples, toWorkout: workout, completion: { (result: Bool, error: NSError?) -> Void in
                    if error == nil {
                        print("samples added to workout")
                    } else {
                        print("error while saving workout samples \(error)")
                    }
                })
            } else {
                print("error while saving workout \(error)")
            }
        }
    }
    
    // MARK: - HKWorkoutSessionDelegate
    
    func workoutSession(workoutSession: HKWorkoutSession, didChangeToState toState: HKWorkoutSessionState, fromState: HKWorkoutSessionState, date: NSDate) {
        print("workout state changed from \(fromState) to \(toState)")
    }
    
    func workoutSession(workoutSession: HKWorkoutSession, didFailWithError error: NSError) {
        print("workout session failed \(error)")
    }
    
}