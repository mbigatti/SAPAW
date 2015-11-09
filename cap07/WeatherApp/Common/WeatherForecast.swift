//
//  WeatherForecast.swift
//  WeatherApp
//
//  Created by Massimiliano Bigatti on 15/07/15.
//  Copyright © 2015 Massimiliano Bigatti. All rights reserved.
//

import Foundation


class WeatherForecast {
    var location : String
    var entries : [WeatherForecastData]
    
    init(location: String, dates: [NSDate], temperatures temps: [String], conditions: [String], icons: [String]) {
        self.location = location
        entries = [WeatherForecastData]()
        
        for var index = 0; index < dates.count - 1; index++ {
            let entry = WeatherForecastData(date: dates[index], temp: temps[index], condition: conditions[index], icon: icons[index])
            entries.append(entry)
        }
    }
    
    func weatherBeforeDate(date: NSDate) -> [WeatherForecastData]? {
        return entries.filter { (element) -> Bool in
            return element.date.compare(date) == .OrderedAscending
        }
    }
    
    func weatherAfterDate(date: NSDate) -> [WeatherForecastData]? {
        return entries.filter { (element) -> Bool in
            return element.date.compare(date) == .OrderedDescending
        }
    }
    
    func weatherForDate(date: NSDate) -> WeatherForecastData? {
        let components1 = NSCalendar.currentCalendar().components(NSCalendarUnit.Hour, fromDate: date)
        
        // print("looking for weather on exact date \(date), hour \(components1.hour)")
        
        let result = entries.filter { (element) -> Bool in
            let components2 = NSCalendar.currentCalendar().components(NSCalendarUnit.Hour, fromDate: element.date)
            return components1.hour == components2.hour
        }
        
        return result.first
    }

    func debugDump() {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        for entry in entries {
            let dateString = dateFormatter.stringFromDate(entry.date)
            print("\(dateString) - \(entry.temp) - \(entry.condition) - \(entry.icon)")
        }
    }
}

class WeatherForecastData {
    var date: NSDate
    var temp: String
    var condition: String
    var icon: String
    
    init(date: NSDate, temp: String, condition: String, icon: String) {
        self.date = date
        self.temp = temp
        self.condition = condition
        self.icon = icon
    }
}