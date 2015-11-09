//
//  TitleRowController.swift
//  CoreMotionCatalog
//
//  Created by Massimiliano Bigatti on 20/10/15.
//  Copyright © 2015 Massimiliano Bigatti. All rights reserved.
//

import Foundation
import WatchKit

class TitleRowController : NSObject {
    
    @IBOutlet var label: WKInterfaceLabel!
    
    func setTitle(title: String) {
        label.setText(title)
    }
    
}