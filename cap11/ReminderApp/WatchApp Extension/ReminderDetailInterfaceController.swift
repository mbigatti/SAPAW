//
//  ReminderDetailInterfaceController.swift
//  ReminderApp
//
//  Created by Massimiliano Bigatti on 24/07/15.
//  Copyright © 2015 Massimiliano Bigatti. All rights reserved.
//

import WatchKit
import Foundation
import EventKit

class ReminderDetailInterfaceController: AbstractReminderInterfaceController {
    
    @IBOutlet var priorityLabel: WKInterfaceLabel!
    @IBOutlet var titleLabel: WKInterfaceLabel!
    @IBOutlet var alarmImage: WKInterfaceImage!
    @IBOutlet var alarmLabel: WKInterfaceLabel!
    @IBOutlet var recurrenceLabel: WKInterfaceLabel!
    @IBOutlet var separator: WKInterfaceSeparator!
    @IBOutlet var notesLabel: WKInterfaceLabel!
    
    var reminder : EKReminder?
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        reminder = context as? EKReminder
        
        reloadData()
    }
    
    
    // MARK: - EKEventStoreChangedNotification
    
    func eventStoreDidChange() {
        reloadData()
    }
    
    
    // MARK: - Privates
    
    func reloadData() {
        print("reloadData()")
        
        if let _reminder = reminder {
            setTitle(reminder?.calendar.title)
            
            let color = UIColor(CGColor: _reminder.calendar.CGColor)            
            
            priorityLabel.setText(_reminder.priority.priorityDescription())
            priorityLabel.setTextColor(color)
            
            titleLabel.setText(_reminder.title)

            if let date = _reminder.alarms?.first?.absoluteDate {
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "dd/MM/yyyy, hh:mm"
                
                alarmLabel.setText(dateFormatter.stringFromDate(date))
                alarmLabel.setTextColor(color)
                alarmImage.setTintColor(color)
                
            } else {
                alarmLabel.setHidden(true)
                alarmImage.setHidden(true)
            }
            
            if let rule = _reminder.recurrenceRules?.first {
                var frequency = ""
                switch rule.frequency {
                    case .Daily: frequency = "giorni"
                    case .Monthly: frequency = "mesi"
                    case .Weekly: frequency = "settimane"
                    case .Yearly: frequency = "anni"
                }
                let text = "Ogni \(rule.interval) \(frequency)"
                recurrenceLabel.setText(text)
                
            } else {
                recurrenceLabel.setHidden(true)
            }
            
            if !_reminder.hasNotes {
                separator.setHidden(true)
                notesLabel.setHidden(true)
                
            } else {
                separator.setColor(color)
                notesLabel.setText(_reminder.notes)
            }
        }
    }
    
}
