//
//  EventDetailInterfaceController.swift
//  CalendarApp
//
//  Created by Massimiliano Bigatti on 27/07/15.
//  Copyright © 2015 Massimiliano Bigatti. All rights reserved.
//

import Foundation
import WatchKit
import EventKit

class EventDetailInterfaceController : WKInterfaceController {
    
    @IBOutlet var titleLabel: WKInterfaceLabel!
    @IBOutlet var locationLabel: WKInterfaceLabel!
    @IBOutlet var dateLabel: WKInterfaceLabel!
    @IBOutlet var calendarSeparator: WKInterfaceSeparator!
    @IBOutlet var calendarLabel: WKInterfaceLabel!
    
    var event : EKEvent?
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        event = context as? EKEvent
        reloadData()
    }
    
    func reloadData() {
        if let _event = event {
            titleLabel.setText(_event.title)
            if let location = _event.location {
                locationLabel.setText(location)
            }
            
            dateLabel.setText(_event.dateInterval())
            
            calendarSeparator.setColor(UIColor(CGColor: _event.calendar.CGColor))
            calendarLabel.setText(_event.calendar.title)
        }
    }
}