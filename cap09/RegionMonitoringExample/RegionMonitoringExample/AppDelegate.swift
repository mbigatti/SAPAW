//
//  AppDelegate.swift
//  RegionMonitoringExample
//
//  Created by Massimiliano Bigatti on 30/07/15.
//  Copyright © 2015 Massimiliano Bigatti. All rights reserved.
//

import UIKit
import CoreLocation
import WatchConnectivity


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate, WCSessionDelegate {
    
    var window: UIWindow?
    
    let manager = CLLocationManager()
    var session : WCSession?
    
    //
    // MARK: - UIApplicationDelegate
    //
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        if CLLocationManager.locationServicesEnabled() {
            manager.delegate = self
            
            switch CLLocationManager.authorizationStatus() {
            case .NotDetermined:
                print("requesting always authorization")
                manager.requestAlwaysAuthorization()
                
            case .AuthorizedAlways:
                startRegionMonitoring()
                
            default:
                break
            }
            
        } else {
            print("location service not available")
            
        }
        
        if WCSession.isSupported() {
            session = WCSession.defaultSession()
            session?.delegate = self
            session?.activateSession()
            
        } else {
            print("watch connectivity not available")
        }
        
        return true
    }
    
    
    //
    // MARK: - CLLocationManagerDelegate
    //
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        print("didChangeAuthorizationStatus")
        
        if status == .AuthorizedAlways {
            startRegionMonitoring()
        }
    }
    
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("didEnterRegion \(region)")
        
        if let _session = session {
            if _session.paired {
                _session.sendMessage([kEventMessageKey: kDidEnterRegionMessageValue], replyHandler: nil, errorHandler: { (error: NSError) -> Void in
                    print("error sending message to Watch \(error)")
                })
            }
        }
    }
    
    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("didExitRegion \(region)")
        
        if let _session = session {
            if _session.paired {
                _session.sendMessage([kEventMessageKey: kDidExitRegionMessageValue], replyHandler: nil, errorHandler: { (error: NSError) -> Void in
                    print("error sending message to Watch \(error)")
                })
            }
        }
    }
    
    
    //
    // MARK: - Privates
    //
    
    func startRegionMonitoring() {
        print("startRegionMonitoring")
        
        let radiusMeters : CLLocationDistance = 300
        let coordinates = CLLocationCoordinate2D(latitude: 45.464115, longitude: 9.191914)
        let region = CLCircularRegion(center: coordinates, radius: radiusMeters, identifier: "Milano")
        
        manager.startMonitoringForRegion(region)
    }
    
}

