//
//  TodayEventsInterfaceController.swift
//  WatchApp Extension
//
//  Created by Massimiliano Bigatti on 26/07/15.
//  Copyright © 2015 Massimiliano Bigatti. All rights reserved.
//

import WatchKit
import Foundation
import EventKit


class TodayEventsInterfaceController: WKInterfaceController {
    
    @IBOutlet var table: WKInterfaceTable!
    
    let eventStore = EKEventStore()
    var events : [EKEvent]?

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        switch EKEventStore.authorizationStatusForEntityType(.Reminder) {
        case .NotDetermined:
            eventStore.requestAccessToEntityType(.Reminder) { (granted: Bool, error: NSError?) -> Void in
                if error == nil {
                    if granted {
                        self.eventStore.reset() // ???
                        self.reloadTable()
                    } else {
                        print("Authorization not granted")
                    }
                } else {
                    print("Error authorizing access to reminders \(error)")
                }
            }
            
        case .Authorized:
            reloadTable()
            
        default:
            print("Event Store not available")
        }
    }

    override func table(table: WKInterfaceTable, didSelectRowAtIndex rowIndex: Int) {
        self.pushControllerWithName("EventDetail", context: events![rowIndex])
    }

    func reloadTable() {
        print("reloadTable()")
        
        //
        // compute start / end date
        //
        let calendar = NSCalendar.currentCalendar()
        let now = NSDate()
        let components = calendar.components([.Year, .Month, .Day], fromDate: now)
        
        let startDate = calendar.dateFromComponents(components)!
        
        let endDate = calendar.dateByAddingUnit(NSCalendarUnit.Day,
            value: 1, toDate: startDate, options: NSCalendarOptions())!
        
        //
        // query today events
        //
        let predicate = eventStore.predicateForEventsWithStartDate(startDate, endDate: endDate, calendars: nil)
        events = eventStore.eventsMatchingPredicate(predicate)
        
        table.setNumberOfRows(events!.count, withRowType: "EventRowController")
        
        for index in 0..<events!.count {
            let row = table.rowControllerAtIndex(index) as! EventRowController
            let event = events![index]
            
            row.setColor(event.calendar.CGColor)
            row.setTitle(event.title)
            row.setDateInterval(event.dateInterval())
        }
        
    }
    
}
