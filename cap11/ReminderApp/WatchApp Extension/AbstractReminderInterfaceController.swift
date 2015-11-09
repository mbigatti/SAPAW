//
//  AbstractReminderInterfaceController.swift
//  ReminderApp
//
//  Created by Massimiliano Bigatti on 25/07/15.
//  Copyright © 2015 Massimiliano Bigatti. All rights reserved.
//

import WatchKit
import Foundation
import EventKit

class AbstractReminderInterfaceController: WKInterfaceController {
    
    override func willActivate() {
        super.willActivate()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "eventStoreDidChange", name: EKEventStoreChangedNotification, object: nil)
    }
    
    override func didDeactivate() {
        super.didDeactivate()
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
}