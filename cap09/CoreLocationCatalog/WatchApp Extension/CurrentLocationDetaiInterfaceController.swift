//
//  CurrentLocationDetaiInterfaceController.swift
//  CoreLocationCatalog
//
//  Created by Massimiliano Bigatti on 09/07/15.
//  Copyright © 2015 Massimiliano Bigatti. All rights reserved.
//

import WatchKit
import Foundation


class CurrentLocationDetailInterfaceController: WKInterfaceController {
    @IBOutlet weak var table: WKInterfaceTable!
    
    let descriptions = [
        "Nome",                         // name
        "Latitudine / longitudine",     // location
        
        "Via transitabile 1",           // thoroughfare
        "Via transitabile 2",           // subThoroughfare
        "Codice postale",               // postalCode
        "Località",                     // locality
        "Sotto località",               // subLocality
        "Area amministrativa",          // administrativeArea
        "Sotto area amministrativa",    // subAdministrativeArea
        "Area logica",                  // region
        "Stato",                        // country
        "Stato (ISO)",                  // ISOcountryCode
        "Fuso orario",                  // timeZone
        
        "Area di interesse",            // areaOfInterest
        "Lago/fiume/torrente",          // inlandWater
        "Oceano"                        // ocean
    ]
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        let placemark = context as! CLPlacemark
        
        var data = [String?]()
        
        data.append(placemark.name)
        if let coordinate = placemark.location?.coordinate {
            data.append("\(coordinate.latitude), \(coordinate.longitude)")
        } else {
            data.append(nil)
        }
        
        data.append(placemark.thoroughfare)
        data.append(placemark.subThoroughfare)
        data.append(placemark.postalCode)
        data.append(placemark.locality)
        data.append(placemark.subLocality)
        data.append(placemark.administrativeArea)
        data.append(placemark.subAdministrativeArea)
        data.append(placemark.region?.identifier)
        data.append(placemark.country)
        data.append(placemark.ISOcountryCode)
        data.append(placemark.timeZone?.description)
        
        if let areas = placemark.areasOfInterest {
            data.append("\(areas)")
        } else {
            data.append(nil)
        }
        
        data.append(placemark.inlandWater)
        data.append(placemark.ocean)
        
        table.setNumberOfRows(descriptions.count, withRowType: "LocationDetailRowController")
        
        for index in 0..<descriptions.count {
            let rowController = self.table.rowControllerAtIndex(index) as! LocationDetailRowController
            
            rowController.setContent(data[index])
            rowController.setDescription(descriptions[index])
        }
    }
    
}

