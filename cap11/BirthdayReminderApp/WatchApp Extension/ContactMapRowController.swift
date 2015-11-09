//
//  ContactMapRowController.swift
//  BirthdayReminderApp
//
//  Created by Massimiliano Bigatti on 27/07/15.
//  Copyright © 2015 Massimiliano Bigatti. All rights reserved.
//

import Foundation
import WatchKit

class ContactMapRowController : NSObject {
    
    @IBOutlet weak var map: WKInterfaceMap!

    func setCoordinate(coordinate: CLLocationCoordinate2D) {
        var coordinateRegion = MKCoordinateRegion()
        coordinateRegion.center = CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude)
        coordinateRegion.span = MKCoordinateSpanMake(0.1,  0.1)
        
        let mapRect = MKMapRect(origin: MKMapPointForCoordinate(coordinateRegion.center), size: MKMapSize(width: 0.5, height: 0.5))
        
        map.addAnnotation(coordinate, withPinColor: .Purple)
        map.setVisibleMapRect(mapRect)
        map.setRegion(coordinateRegion)
    }
    
}