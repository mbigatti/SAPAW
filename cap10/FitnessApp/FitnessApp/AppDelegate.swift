//
//  AppDelegate.swift
//  FitnessApp
//
//  Created by Massimiliano Bigatti on 29/06/15.
//  Copyright © 2015 Massimiliano Bigatti. All rights reserved.
//

import UIKit
import HealthKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let healthStore = HKHealthStore()

    //
    // authorization from watch
    //
    func applicationShouldRequestHealthAuthorization(application: UIApplication) {
        print("applicationShouldRequestHealthAuthorization")
        
        self.healthStore.handleAuthorizationForExtensionWithCompletion { success, error in
            if error != nil {
                print("Error authorizing HealthKit access \(error)")
            }
            print(success ? " authorized" : " not authorized")
        }
        
    }


}

