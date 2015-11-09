//
//  ComplicationController.swift
//  WatchApp Extension
//
//  Created by Massimiliano Bigatti on 10/10/15.
//  Copyright © 2015 Massimiliano Bigatti. All rights reserved.
//

import ClockKit


class ComplicationController: NSObject, CLKComplicationDataSource {
    
    // MARK: - Timeline Configuration
    
    func getSupportedTimeTravelDirectionsForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationTimeTravelDirections) -> Void) {
        handler([])
    }
    
    // MARK: - Timeline Population
    
    func getCurrentTimelineEntryForComplication(complication: CLKComplication, withHandler handler: ((CLKComplicationTimelineEntry?) -> Void)) {

        let template = CLKComplicationTemplateCircularSmallRingText()
        template.textProvider = CLKSimpleTextProvider(text: "Work day", shortText: "WK")
        template.fillFraction = workdayCompletion()
        let entry = CLKComplicationTimelineEntry(date: NSDate(), complicationTemplate: template)
        
        handler(entry)
    }
    
    // calculate completion against workday 9.00-18.00
    func workdayCompletion() -> Float {
        let calendar = NSCalendar.currentCalendar()
        let now = NSDate()
        let currentHour = Float(calendar.component(NSCalendarUnit.Hour, fromDate: now))
        let currentMinutes = Float(calendar.component(NSCalendarUnit.Minute, fromDate: now))
        
        let startHour : Float = 9
        let hour = (currentHour + currentMinutes / 60) - startHour
        
        return 1.0 / 9 * hour
    }
    
    // MARK: - Placeholder Templates
    
    func getPlaceholderTemplateForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationTemplate?) -> Void) {

        let template = CLKComplicationTemplateCircularSmallRingText()
        template.textProvider = CLKSimpleTextProvider(text: "Work day", shortText: "WK")

        handler(template)
    }
    
}
