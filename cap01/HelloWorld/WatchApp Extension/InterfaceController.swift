//
//  InterfaceController.swift
//  WatchApp Extension
//
//  Created by Massimiliano Bigatti on 19/10/15.
//  Copyright © 2015 Massimiliano Bigatti. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    @IBOutlet var label: WKInterfaceLabel!
    
    @IBAction func buttonPressed() {
        label.setText("Hello Watch 😃")
    }    

}
