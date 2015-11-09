//
//  EKEvent+Duration.swift
//  CalendarApp
//
//  Created by Massimiliano Bigatti on 27/07/15.
//  Copyright © 2015 Massimiliano Bigatti. All rights reserved.
//

import Foundation
import EventKit

extension EKEvent {
    
    func dateInterval() -> String {
        if allDay {
            return "Tutto il giorno"
        }
        
        let calendar = NSCalendar.currentCalendar()
        let startDateComponents = calendar.components([.Year, .Month, .Day], fromDate: startDate)
        let endDateComponents = calendar.components([.Year, .Month, .Day], fromDate: endDate)
        
        if startDateComponents.year == endDateComponents.year &&
            startDateComponents.month == endDateComponents.month &&
            startDateComponents.day == endDateComponents.day {
                
            let shortDateFormatter = NSDateFormatter()
            shortDateFormatter.dateFormat = "HH:mm"
                
            return "\(shortDateFormatter.stringFromDate(startDate))–\(shortDateFormatter.stringFromDate(endDate))"
            
        } else {
            let longDateFormatter = NSDateFormatter()
            longDateFormatter.dateFormat = "dd/MM HH:mm"
            
            return "\(longDateFormatter.stringFromDate(startDate))–\(longDateFormatter.stringFromDate(endDate))"
        }
    }
    
}