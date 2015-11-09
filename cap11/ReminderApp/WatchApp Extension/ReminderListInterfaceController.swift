//
//  ReminderListInterfaceController.swift
//  ReminderApp
//
//  Created by Massimiliano Bigatti on 24/07/15.
//  Copyright © 2015 Massimiliano Bigatti. All rights reserved.
//

import WatchKit
import Foundation
import EventKit

class ReminderListInterfaceController: AbstractReminderInterfaceController {
    
    @IBOutlet var table: WKInterfaceTable!
    
    let eventStore = EKEventStore()
    var calendar : EKCalendar?
    var reminders : [EKReminder]?
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        calendar = context as? EKCalendar
        
        reloadTable()
    }
    
    override func table(table: WKInterfaceTable, didSelectRowAtIndex rowIndex: Int) {
        self.pushControllerWithName("ReminderDetail", context: reminders?[rowIndex])
    }

    
    // MARK: - EKEventStoreChangedNotification
    
    func eventStoreDidChange() {
        reloadTable()
    }

    
    // MARK: - Privates
    
    func reloadTable() {
        print("reloadTable()")
        
        let predicate = eventStore.predicateForRemindersInCalendars([calendar!])
        eventStore.fetchRemindersMatchingPredicate(predicate) { (reminders: [EKReminder]?) -> Void in
            if let _reminders = reminders {
                self.reminders = _reminders
                self.table.setNumberOfRows(_reminders.count, withRowType: "ReminderRowController")
                
                for index in 0..<_reminders.count {
                    let row = self.table.rowControllerAtIndex(index) as! ReminderRowController
                    let reminder = _reminders[index]
                    
                    row.setPriority(reminder.priority)
                    row.setColor(self.calendar!.CGColor)
                    row.setText(reminder.title, completed: reminder.completed)
                }
            }
        }
    }
}
