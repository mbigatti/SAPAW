//
//  ContactSummaryRowController.swift
//  BirthdayReminderApp
//
//  Created by Massimiliano Bigatti on 27/07/15.
//  Copyright © 2015 Massimiliano Bigatti. All rights reserved.
//

import Foundation
import WatchKit

let kBirthdayDateFormat = "EEE d/M/yy"

class ContactSummaryRowController : NSObject {
    
    @IBOutlet weak var image: WKInterfaceImage!
    @IBOutlet weak var nameLabel: WKInterfaceLabel!
    @IBOutlet weak var ageLabel: WKInterfaceLabel!
    @IBOutlet weak var birthdayLabel: WKInterfaceLabel!

    func setImageData(imageData: NSData) {
        image.setImageData(imageData)
    }
    
    func setFullName(fullName: String) {
        nameLabel.setText(fullName)
    }
    
    func setAge(age: Int, onDate birthday: NSDate) {
        let formatter = NSDateFormatter()
        formatter.dateFormat = kBirthdayDateFormat
        
        ageLabel.setText("\(age) anni \(formatter.stringFromDate(birthday))")
    }
    
    func setBirthday(birthday: NSDate) {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        
        birthdayLabel.setText(formatter.stringFromDate(birthday))
    }
}