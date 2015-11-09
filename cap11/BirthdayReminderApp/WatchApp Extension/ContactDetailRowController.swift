//
//  ContactDetailRowController.swift
//  BirthdayReminderApp
//
//  Created by Massimiliano Bigatti on 27/07/15.
//  Copyright © 2015 Massimiliano Bigatti. All rights reserved.
//

import Foundation
import WatchKit

class ContactDetailRowController : NSObject {
    
    @IBOutlet weak var valueLabel: WKInterfaceLabel!
    @IBOutlet weak var descriptionLabel: WKInterfaceLabel!
    
    func setValue(value: String) {
        valueLabel.setText(value)
    }
    
    func setDescription(description: String) {
        descriptionLabel.setText(description)
    }
    
}