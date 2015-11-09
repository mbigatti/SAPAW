//
//  ComplicationController.swift
//  WatchApp Extension
//
//  Created by Massimiliano Bigatti on 14/10/15.
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
        
        if let url = NSURL(string: "https://api.github.com/users/mbigatti") {
            let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) -> Void in
                let template = CLKComplicationTemplateCircularSmallStackText()
                
                if (error == nil) {
                    print("data downloaded")
                    
                    do {
                        let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as! NSDictionary
                        
                        let followers = json.objectForKey("followers") as! Int
                        
                        template.line1TextProvider = CLKSimpleTextProvider(text: "Followers", shortText: "FOLL")
                        template.line2TextProvider = CLKSimpleTextProvider(text: "\(followers)")
                        
                    } catch {
                        print("error deserializing JSON data")
                    }
                    
                } else {
                    print("Error fetching data \(error)")
                    template.line1TextProvider = CLKSimpleTextProvider(text: "Error", shortText: "ERR")
                    template.line1TextProvider = CLKSimpleTextProvider(text: "Unknown", shortText: "???")
                }
                
                
                let entry = CLKComplicationTimelineEntry(date: NSDate(), complicationTemplate: template)
                
                handler(entry)
            }
            
            task.resume()
        }
    }

    
    // MARK: - Placeholder Templates
    
    func getPlaceholderTemplateForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationTemplate?) -> Void) {
        
        let template = CLKComplicationTemplateCircularSmallRingText()
        template.textProvider = CLKSimpleTextProvider(text: "--")
        
        handler(template)
    }
    
}
