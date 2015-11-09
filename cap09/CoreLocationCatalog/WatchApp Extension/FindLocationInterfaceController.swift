//
//  FindLocationInterfaceController.swift
//  CoreLocationCatalog
//
//  Created by Massimiliano Bigatti on 09/07/15.
//  Copyright © 2015 Massimiliano Bigatti. All rights reserved.
//

import WatchKit
import Foundation
import CoreLocation


class FindLocationInterfaceController: WKInterfaceController {
    let geocoder = CLGeocoder()
    
    @IBOutlet var map: WKInterfaceMap!
    @IBOutlet var label: WKInterfaceLabel!
    
    override func willActivate() {
        super.willActivate()
        
        let suggestions = [ "Milano", "Roma", "New York", "Londra", "Berlino" ]
        
        self.presentTextInputControllerWithSuggestions(suggestions, allowedInputMode: .Plain) { (selection) -> Void in            
            print("geocoding \(selection)")
            
            if let query = selection?.last as? String {
                self.geocoder.geocodeAddressString(query, completionHandler: { (placemarks:[CLPlacemark]?, error:NSError?) -> Void in
                    if error == nil {
                        if let placemark = placemarks?.last {
                            self.updateUI(placemark)
                        }
                        /*
                        for placemark in placemarks! {
                            print("name \(placemark.name)")
                        }
                        */
                        
                    } else {
                        print("error \(error)")
                    }
                })
            } else {
                self.label.setText("Nessuna selezione")
            }
        }
    }
    
    func updateUI(placemark: CLPlacemark) {
        if let name = placemark.name {
            label.setText("Found: \(name)")
        }
        
        if let coordinate = placemark.location?.coordinate {
            var coordinateRegion = MKCoordinateRegion()
            coordinateRegion.center = CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude)
            coordinateRegion.span = MKCoordinateSpanMake(0.1,  0.1)
            
            let mapRect = MKMapRect(origin: MKMapPointForCoordinate(coordinateRegion.center), size: MKMapSize(width: 0.5, height: 0.5))
            
            map.addAnnotation(coordinate, withPinColor: .Red)
            map.setVisibleMapRect(mapRect)
            map.setRegion(coordinateRegion)
        }
    }
    
}



