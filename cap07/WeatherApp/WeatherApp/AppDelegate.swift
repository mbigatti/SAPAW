//
//  AppDelegate.swift
//  WeatherApp
//
//  Created by Massimiliano Bigatti on 18/06/15.
//  Copyright © 2015 Massimiliano Bigatti. All rights reserved.
//

import UIKit
import CoreLocation


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        WeatherDataFetcher.sharedInstance.fetchWeather()
        
        return true
    }
    
}

