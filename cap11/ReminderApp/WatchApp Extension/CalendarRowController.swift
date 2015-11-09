//
//  CalendarRowController.swift
//  ReminderApp
//
//  Created by Massimiliano Bigatti on 24/07/15.
//  Copyright © 2015 Massimiliano Bigatti. All rights reserved.
//

import Foundation
import WatchKit

class CalendarRowController : NSObject {
    
    @IBOutlet weak var separator: WKInterfaceSeparator!
    @IBOutlet weak var label: WKInterfaceLabel!

    func setColor(color: CGColor) {
        separator.setColor(UIColor(CGColor: color))
    }
    
    func setText(text: String) {
        label.setText(text)
    }

}