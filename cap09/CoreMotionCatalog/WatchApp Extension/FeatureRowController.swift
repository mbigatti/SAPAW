//
//  FeatureRowController.swift
//  CoreMotionCatalog
//
//  Created by Massimiliano Bigatti on 20/10/15.
//  Copyright © 2015 Massimiliano Bigatti. All rights reserved.
//

import Foundation
import WatchKit

class FeatureRowController : NSObject {
    
    @IBOutlet var featureLabel: WKInterfaceLabel!
    @IBOutlet var featureAvailable: WKInterfaceLabel!
    
    func setDescription(description: String) {
        featureLabel.setText(description)
    }
    
    func setAvailable(available: Bool) {
        featureAvailable.setHidden(!available)
        
        if !available {
            featureLabel.setTextColor(UIColor.darkGrayColor())
        }
    }
}
