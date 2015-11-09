//
//  CNContact+Birthday.swift
//  BirthdayReminderApp
//
//  Created by Massimiliano Bigatti on 27/07/15.
//  Copyright © 2015 Massimiliano Bigatti. All rights reserved.
//

import Foundation
import Contacts

extension CNContact {
    
    func birthdayData() -> (birthdayDate: NSDate, age: Int, nextBirthdayDate: NSDate)? {
        if let birthday = birthday {
            if let birthDayDate = NSCalendar.currentCalendar().dateFromComponents(birthday) {
                birthday.year = NSCalendar.currentCalendar().component(.Year, fromDate: NSDate())
                
                if let nextBirthdayDate = NSCalendar.currentCalendar().dateFromComponents(birthday) {
                    let differenceComponents = NSCalendar.currentCalendar().components(.Year, fromDate: birthDayDate, toDate: nextBirthdayDate, options: NSCalendarOptions(rawValue: 0) )
                    
                    return (birthdayDate: birthDayDate, age: differenceComponents.year, nextBirthdayDate: nextBirthdayDate)
                }
            }
        }
        
        return nil
    }
    
}