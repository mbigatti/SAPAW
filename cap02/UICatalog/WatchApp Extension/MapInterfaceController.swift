//
//  MapInterfaceController.swift
//  UICatalog
//
//  Created by Massimiliano Bigatti on 23/06/15.
//  Copyright © 2015 Massimiliano Bigatti. All rights reserved.
//

import WatchKit

class MapInterfaceController : WKInterfaceController {
    
    @IBOutlet var map: WKInterfaceMap!
    
    override func willActivate() {
        super.willActivate()
        
        let latitude = 45.464115
        let longitude = 9.191914
        
        var coordinateRegion = MKCoordinateRegion()
        coordinateRegion.center = CLLocationCoordinate2DMake(latitude, longitude)
        coordinateRegion.span = MKCoordinateSpanMake(0.1,  0.1)
        
        let mapRect = MKMapRect(origin: MKMapPointForCoordinate(coordinateRegion.center), size: MKMapSize(width: 0.5, height: 0.5))
        
        map.addAnnotation(coordinateRegion.center, withPinColor: .Red)
        map.setVisibleMapRect(mapRect)
        map.setRegion(coordinateRegion)
    }
    
}
