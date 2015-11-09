//
//  ComplicationController.swift
//  WatchApp Extension
//
//  Created by Massimiliano Bigatti on 18/06/15.
//  Copyright © 2015 Massimiliano Bigatti. All rights reserved.
//

import ClockKit
import WatchKit

class ComplicationController: NSObject, CLKComplicationDataSource {
    
    
    //
    // MARK: - Timeline Configuration
    //
    
    func getSupportedTimeTravelDirectionsForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationTimeTravelDirections) -> Void) {
        handler([.Forward, .Backward])
    }
    
    func getTimelineStartDateForComplication(complication: CLKComplication, withHandler handler: (NSDate?) -> Void) {
        print("start date for complication \(weatherForecast?.entries.first?.date)")
        handler(weatherForecast?.entries.first?.date)
    }
    
    func getTimelineEndDateForComplication(complication: CLKComplication, withHandler handler: (NSDate?) -> Void) {
        print("end date for complication \(weatherForecast?.entries.last?.date)")
        handler(weatherForecast?.entries.last?.date)
    }
    
    // Privacy
    
    func getPrivacyBehaviorForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationPrivacyBehavior) -> Void) {
        handler(.ShowOnLockScreen)
    }
    
    
    //
    // MARK: - Timeline Population
    //
    
    func getCurrentTimelineEntryForComplication(complication: CLKComplication, withHandler handler: ((CLKComplicationTimelineEntry?) -> Void)) {
        print("getCurrentTimelineEntryForComplication")
        
        guard weatherForecast != nil else {
            handler(nil)
            return
        }
        
        if let weatherForecastData = weatherForecast?.weatherForDate(NSDate()) {
            handler(getTimelineEntryForComplication(complication, withData: weatherForecastData))
        }
    }
    
    func getTimelineEntriesForComplication(complication: CLKComplication, beforeDate date: NSDate, limit: Int, withHandler handler: (([CLKComplicationTimelineEntry]?) -> Void)) {
        
        print("getTimelineEntriesForComplication beforeDate \(date) \(date.timeIntervalSince1970), limit \(limit)")
        
        handler(getTimelineEntriesForComplication(complication, forWeatherForecastData: weatherForecast?.weatherBeforeDate(date), limit: limit))
    }
    
    func getTimelineEntriesForComplication(complication: CLKComplication, afterDate date: NSDate, limit: Int, withHandler handler: (([CLKComplicationTimelineEntry]?) -> Void)) {
        
        print("getTimelineEntriesForComplication afterDate \(date) \(date.timeIntervalSince1970), limit \(limit)")
        
        handler(getTimelineEntriesForComplication(complication, forWeatherForecastData: weatherForecast?.weatherAfterDate(date), limit: limit))
    }
    
    private func getTimelineEntriesForComplication(complication: CLKComplication, forWeatherForecastData weatherForecastDataArray: [WeatherForecastData]?, limit: Int) -> [CLKComplicationTimelineEntry] {
        var entries = [CLKComplicationTimelineEntry]()
        
        if let _weatherForecastDataArray = weatherForecastDataArray {
            for weatherForecastData in _weatherForecastDataArray {
                if let entry = getTimelineEntryForComplication(complication, withData: weatherForecastData) {
                    entries.append(entry)
                    if entries.count == limit {
                        break
                    }
                }
            }
        }
        
        /*
        print("entries count \(entries.count)")
        for entry in entries {
            print("  \(entry.date) \(entry.date.timeIntervalSince1970)")
        }
        */
        
        return entries
    }
    
    func getTimelineEntryForComplication(complication: CLKComplication, withData data : WeatherForecastData) -> CLKComplicationTimelineEntry? {
        // print("getTimelineEntryForComplication, date \(date)")
        
        var template: CLKComplicationTemplate? = nil
        
        let tempAndCondition = "\(data.temp)° \(data.condition)"
        
        let tempTextProvider = CLKSimpleTextProvider(text: "\(data.temp)°")
        let conditionImageProvider = CLKImageProvider(onePieceImage: UIImage(named: data.icon)!)
        let conditionTextProvider = CLKSimpleTextProvider(text: data.condition)
        let tempAndConditionTextProvider = CLKSimpleTextProvider(text: tempAndCondition, shortText: data.temp)
        
        // print("  \(tempAndCondition)")
        
        switch complication.family {
            case .ModularSmall:
                let modularSmallTemplate = CLKComplicationTemplateModularSmallStackImage()
                modularSmallTemplate.line1ImageProvider = conditionImageProvider
                modularSmallTemplate.line2TextProvider = conditionTextProvider
                template = modularSmallTemplate
            
            case .ModularLarge:
                let modularLargeTemplate = CLKComplicationTemplateModularLargeStandardBody()
                if let text = weatherForecast?.location {
                    modularLargeTemplate.headerTextProvider = CLKSimpleTextProvider(text: text)
                }
                modularLargeTemplate.body1TextProvider = tempTextProvider
                modularLargeTemplate.body2TextProvider = conditionTextProvider
                template = modularLargeTemplate
            
            case .UtilitarianSmall:
                let utilitarianSmallTemplate = CLKComplicationTemplateUtilitarianSmallFlat()
                utilitarianSmallTemplate.textProvider = tempAndConditionTextProvider
                template = utilitarianSmallTemplate
            
            case .UtilitarianLarge:
                let utilitarianLargeTemplate = CLKComplicationTemplateUtilitarianLargeFlat()
                utilitarianLargeTemplate.textProvider = tempAndConditionTextProvider
                utilitarianLargeTemplate.imageProvider = conditionImageProvider
                template = utilitarianLargeTemplate
            
            case .CircularSmall:
                let circularSmallTemplate = CLKComplicationTemplateCircularSmallStackImage()
                circularSmallTemplate.line1ImageProvider = conditionImageProvider
                circularSmallTemplate.line2TextProvider = conditionTextProvider
                template = circularSmallTemplate
        }
        
        if let _template = template {
            return CLKComplicationTimelineEntry(date: data.date, complicationTemplate: _template)
        
        } else {
            return nil
        }
    }
    

    //
    // MARK: - Update Scheduling
    //
    
    func getNextRequestedUpdateDateWithHandler(handler: (NSDate?) -> Void) {
        handler(NSDate(timeIntervalSinceNow: 3 * 60 * 60));
    }
    
    func requestedUpdateBudgetExhausted() {
        print("requestedUpdateBudgetExhausted")
    }
    
    func requestedUpdateDidBegin() {
        print("requestedUpdateDidBegin")
        
        let complicationServer = CLKComplicationServer.sharedInstance()
        if let complications = complicationServer.activeComplications {
            for complication in complications {
                complicationServer.extendTimelineForComplication(complication)
            }
        }
    }

    
    //
    // MARK: - Placeholder Templates
    //
    
    func getPlaceholderTemplateForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationTemplate?) -> Void) {

        var template: CLKComplicationTemplate? = nil
        let conditionImageProvider = CLKImageProvider(onePieceImage: UIImage(named: "cloudy")!)
        let shortTextProvider = CLKSimpleTextProvider(text: "--")
        let longTextProvider = CLKSimpleTextProvider(text: "-----")
        
        switch complication.family {
        case .ModularSmall:
            let modularSmallTemplate = CLKComplicationTemplateModularSmallStackImage()
            modularSmallTemplate.line1ImageProvider = conditionImageProvider
            modularSmallTemplate.line2TextProvider = shortTextProvider
            template = modularSmallTemplate
            
        case .ModularLarge:
            let modularLargeTemplate = CLKComplicationTemplateModularLargeStandardBody()
            modularLargeTemplate.headerTextProvider = longTextProvider
            modularLargeTemplate.body1TextProvider = longTextProvider
            template = modularLargeTemplate
            
        case .UtilitarianSmall:
            let utilitarianSmallTemplate = CLKComplicationTemplateUtilitarianSmallFlat()
            utilitarianSmallTemplate.textProvider = longTextProvider
            template = utilitarianSmallTemplate
            
        case .UtilitarianLarge:
            let utilitarianLargeTemplate = CLKComplicationTemplateUtilitarianLargeFlat()
            utilitarianLargeTemplate.textProvider = longTextProvider
            template = utilitarianLargeTemplate
            
        case .CircularSmall:
            let circularSmallTemplate = CLKComplicationTemplateCircularSmallStackImage()
            circularSmallTemplate.line1ImageProvider = conditionImageProvider
            circularSmallTemplate.line2TextProvider = shortTextProvider
        }
        
        handler(template)
    }
    
}
