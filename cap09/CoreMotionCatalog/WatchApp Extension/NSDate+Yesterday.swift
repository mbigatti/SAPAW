//
//  NSDate+Yesterday.swift
//  CoreMotionCatalog
//
//  Created by Massimiliano Bigatti on 20/10/15.
//  Copyright © 2015 Massimiliano Bigatti. All rights reserved.
//

import Foundation

extension NSDate {
    
    //
    // @see: https://github.com/thoughtbot/Tropos/blob/dc2ed3d407a6ee3099fbc630a24fb70f43d9fbec/Tropos/Categories/NSDate%2BTRRelativeDate.m
    //
    
    class func yesterday() -> NSDate {
        let calendar = NSCalendar.currentCalendar()
        
        let today = calendar.components([.Hour, .Minute, .Second, .Day, .Month, .Year], fromDate: NSDate())
        today.day--
        
        return calendar.dateFromComponents(today)!
    }
    
}