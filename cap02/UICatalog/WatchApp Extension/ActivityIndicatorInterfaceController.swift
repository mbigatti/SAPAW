//
//  ActivityIndicatorInterfaceController.swift
//  UICatalog
//
//  Created by Massimiliano Bigatti on 09/07/15.
//  Copyright © 2015 Massimiliano Bigatti. All rights reserved.
//

import WatchKit
import Foundation


class ActivityIndicatorInterfaceController : WKInterfaceController {
    
    @IBOutlet var image: WKInterfaceImage!
    @IBOutlet var button: WKInterfaceButton!
    
    var animating = false
    
    @IBAction func startStopButtonTapped() {
        image.setHidden(animating)
        button.setTitle(animating ? "Avvia" : "Interrompi")
        animating = !animating
    }
    
}
