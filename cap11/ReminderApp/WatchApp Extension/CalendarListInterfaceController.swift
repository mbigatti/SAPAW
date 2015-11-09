//
//  CalendarListInterfaceController.swift
//  ReminderApp
//
//  Created by Massimiliano Bigatti on 24/07/15.
//  Copyright © 2015 Massimiliano Bigatti. All rights reserved.
//

import WatchKit
import Foundation
import EventKit

class CalendarListInterfaceController: AbstractReminderInterfaceController {
    
    @IBOutlet var table: WKInterfaceTable!
    
    let eventStore = EKEventStore()
    var calendars : [EKCalendar]?
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)

        switch EKEventStore.authorizationStatusForEntityType(.Reminder) {
        case .NotDetermined:
            eventStore.requestAccessToEntityType(.Reminder) { (granted: Bool, error: NSError?) -> Void in
                if error == nil {
                    if granted {
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
        self.pushControllerWithName("ReminderList", context: calendars![rowIndex])
    }

    
    // MARK: - EKEventStoreChangedNotification
    
    func eventStoreDidChange() {
        reloadTable()
    }
    
    
    // MARK: - Privates
    
    func reloadTable() {
        print("reloadTable()")
        
        calendars = eventStore.calendarsForEntityType(.Reminder)
        table.setNumberOfRows(calendars!.count, withRowType: "CalendarRowController")
        
        for index in 0..<calendars!.count {
            let row = table.rowControllerAtIndex(index) as! CalendarRowController
            let calendar = calendars![index]
            
            row.setColor(calendar.CGColor)
            row.setText(calendar.title)
        }
    }
}
