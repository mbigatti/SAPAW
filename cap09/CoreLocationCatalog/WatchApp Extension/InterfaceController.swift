//
//  InterfaceController.swift
//  WatchApp Extension
//
//  Created by Massimiliano Bigatti on 13/07/15.
//  Copyright © 2015 Massimiliano Bigatti. All rights reserved.
//

import WatchKit
import Foundation
import CoreLocation

class InterfaceController: WKInterfaceController, CLLocationManagerDelegate {
    
    @IBOutlet var currentLocationButton: WKInterfaceButton!
    @IBOutlet var findLocationButton: WKInterfaceButton!
    
    
    //
    // MARK: - WKInterfaceController
    //

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)

        currentLocationButton.setEnabled(false)
        findLocationButton.setEnabled(false)
    }
    
    override func willActivate() {
        if CLLocationManager.locationServicesEnabled() {
            
            let manager = CLLocationManager()
            manager.delegate = self
            
            switch CLLocationManager.authorizationStatus() {
            case .NotDetermined:
                print("authorization requested")
                manager.requestWhenInUseAuthorization()
                
            case .AuthorizedWhenInUse:
                currentLocationButton.setEnabled(true)
                findLocationButton.setEnabled(true)
                
            default:
                break
            }
            
        } else {
            print("location service not available")
        }
    }

    
    //
    // MARK: - CLLocationManagerDelegate
    //
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        print("didChangeAuthorizationStatus")
        
        if status == .AuthorizedWhenInUse {
            currentLocationButton.setEnabled(true)
            findLocationButton.setEnabled(true)
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("error while requesting authorization \(error)")
    }
    
}
