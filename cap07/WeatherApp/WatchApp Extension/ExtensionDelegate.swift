//
//  ExtensionDelegate.swift
//  WatchApp Extension
//
//  Created by Massimiliano Bigatti on 18/06/15.
//  Copyright © 2015 Massimiliano Bigatti. All rights reserved.
//

import WatchKit
import WatchConnectivity
import ClockKit


var weatherForecast : WeatherForecast?


class ExtensionDelegate: NSObject, WKExtensionDelegate, WCSessionDelegate {
    let session = WCSession.defaultSession()
    
    private var requestPending = false
    
    func applicationDidFinishLaunching() {
        requestData()
    }
    
    func requestData() {
        session.delegate = self
        session.activateSession()
        
        if requestPending {
            print("weather data request already pending")
            
        } else {
            print("requesting weather data to iPhone App, supported=\(WCSession.isSupported()), reachable=\(session.reachable)")
            
            if WCSession.isSupported() && session.reachable {
                requestPending = true
                
                session.sendMessage(["dummy": "dummy"], replyHandler: nil) { (error: NSError) -> Void in
                    print("error while requesting weather data \(error)")
                    self.requestPending = false
                }
                
            } else {
                print("Watch Connectivity not available")
            }
        }
    }
    
    func session(session: WCSession, didReceiveApplicationContext applicationContext: [String : AnyObject]) {
        print("received weather data from iPhone App")
        
        weatherForecast = WeatherForecast(
            location: (applicationContext["location"] as? String)!,
            dates: applicationContext["dates"] as! [NSDate],
            temperatures: applicationContext["temps"] as! [String],
            conditions: applicationContext["conditions"] as! [String],
            icons: applicationContext["icons"] as! [String])
        
        weatherForecast!.debugDump()
        
        // notify UI
        NSNotificationCenter.defaultCenter().postNotificationName(kDidReceiveWeatherDataFromPhone, object: self, userInfo: nil)
        
        // refresh complications data
        let complicationServer = CLKComplicationServer.sharedInstance()
        if let complications = complicationServer.activeComplications {
            for complication in complications {
                complicationServer.reloadTimelineForComplication(complication)
            }
        }
        
        // reset flag
        requestPending = false
    }

}
