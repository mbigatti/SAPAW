//
//  CurrentLocationInterfaceController.swift
//  CoreLocationCatalog
//
//  Created by Massimiliano Bigatti on 08/07/15.
//  Copyright © 2015 Massimiliano Bigatti. All rights reserved.
//

import WatchKit
import Foundation
import CoreLocation


class CurrentLocationInterfaceController: WKInterfaceController, CLLocationManagerDelegate {
    let manager = CLLocationManager()
    let geocoder = CLGeocoder()
    
    var currentPlacemark: CLPlacemark?
    
    @IBOutlet var headlineLabel: WKInterfaceLabel!
    @IBOutlet var subtitleLabel: WKInterfaceLabel!
    @IBOutlet var errorLabel: WKInterfaceLabel!
    
    @IBOutlet var detailButton: WKInterfaceButton!
    
    
    //
    // MARK: - WKInterfaceController
    //
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        headlineLabel.setText("")
        subtitleLabel.setText("")
        errorLabel.setText("")
        
        detailButton.setEnabled(false)
    }
    
    override func willActivate() {
        super.willActivate()
        
        manager.delegate = self
        manager.requestLocation()
    }
    
    override func contextForSegueWithIdentifier(segueIdentifier: String) -> AnyObject? {
        return self.currentPlacemark
    }
    

    //
    // MARK: - CLLocationManagerDelegate
    //
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        errorLabel.setText(error.description)
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard locations.count != 0 else {
            return
        }
        
        errorLabel.setText("")
        
        if let location = locations.last {
            geocoder.reverseGeocodeLocation(location) { (placemarks: [CLPlacemark]?, error: NSError?) -> Void in
                if error == nil {
                    if placemarks?.last != nil {
                        self.currentPlacemark = placemarks?.last
                        self.headlineLabel.setText(self.currentPlacemark?.name)
                        
                        self.detailButton.setEnabled(true)
                    }
                    
                } else {
                    print("error while reverse geocoding location \(error)")
                    self.errorLabel.setText(error!.description)
                }
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                let message = "(\(location.coordinate.latitude), \(location.coordinate.longitude))"
                
                print(message)
                self.subtitleLabel.setText(message)
            }
        }
    }
    
}
