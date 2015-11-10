//
//  AudioRowController.swift
//  MultimediaCatalog
//
//  Created by Massimiliano Bigatti on 10/07/15.
//  Copyright © 2015 Massimiliano Bigatti. All rights reserved.
//

import WatchKit

class AudioRowController : NSObject {
    
    @IBOutlet weak var dateLabel: WKInterfaceLabel!
    @IBOutlet weak var durationLabel: WKInterfaceLabel!
    
    let dateFormatter = NSDateFormatter()
    
    func setDate(date: NSDate?) {
        if date == nil {
            dateLabel.setText("")
            
        } else {
            dateFormatter.dateFormat = kAudioClipDataFormat
            dateLabel.setText(dateFormatter.stringFromDate(date!))
        }
    }
    
    func setDuration(duration: NSTimeInterval?) {
        if duration == nil {
            durationLabel.setText("")
            
        } else {
            durationLabel.setText("\(duration!)\"")
        }
    }
}
