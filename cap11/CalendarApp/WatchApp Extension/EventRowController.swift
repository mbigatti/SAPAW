//
//  EventRowController.swift
//  CalendarApp
//
//  Created by Massimiliano Bigatti on 27/07/15.
//  Copyright © 2015 Massimiliano Bigatti. All rights reserved.
//

import Foundation
import WatchKit

class EventRowController : NSObject {
    
    @IBOutlet weak var separator: WKInterfaceSeparator!
    @IBOutlet weak var titleLabel: WKInterfaceLabel!
    @IBOutlet weak var dateLabel: WKInterfaceLabel!
    
    func setColor(color: CGColor) {
        separator.setColor(UIColor(CGColor: color))
    }
    
    func setTitle(title: String) {
        titleLabel.setText(title)
    }
    
    func setDateInterval(dateInterval: String) {
        dateLabel.setText(dateInterval)
    }

}
