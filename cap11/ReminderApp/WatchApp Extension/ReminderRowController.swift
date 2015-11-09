//
//  ReminderRowController.swift
//  ReminderApp
//
//  Created by Massimiliano Bigatti on 24/07/15.
//  Copyright © 2015 Massimiliano Bigatti. All rights reserved.
//

import Foundation
import WatchKit

class ReminderRowController : NSObject {
    
    @IBOutlet weak var priorityLabel: WKInterfaceLabel!
    @IBOutlet weak var titleLabel: WKInterfaceLabel!
    
    func setPriority(priority: Int) {
        priorityLabel.setText(priority.priorityDescription())
    }
    
    func setColor(color: CGColor) {
        priorityLabel.setTextColor(UIColor(CGColor: color))
    }
    
    func setText(text: String, completed: Bool) {
        if completed {
            titleLabel.setAttributedText(NSAttributedString(string: text, attributes: [NSStrikethroughStyleAttributeName : 1]))
        } else {
            titleLabel.setText(text)
        }
    }
    
}

extension Int {

    // Per RFC 5545, priorities of 1-4 are considered "high," a priority of 5 is "medium," and priorities of 6-9 are "low."
    func priorityDescription() -> String {
        if self >= 1 && self <= 4 {
            return "!!!"
            
        } else if self == 5 {
            return "!!"
            
        } else if self >= 6 && self <= 9 {
            return "!"
            
        } else {
            return ""
        }
    }
}