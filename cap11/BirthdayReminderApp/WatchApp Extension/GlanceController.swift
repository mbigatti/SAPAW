//
//  GlanceController.swift
//  WatchApp Extension
//
//  Created by Massimiliano Bigatti on 17/07/15.
//  Copyright © 2015 Massimiliano Bigatti. All rights reserved.
//

import WatchKit
import Foundation
import Contacts

class GlanceController: WKInterfaceController {
    
    @IBOutlet weak var image: WKInterfaceImage!
    @IBOutlet weak var nameLabel: WKInterfaceLabel!
    @IBOutlet weak var ageLabel: WKInterfaceLabel!
    @IBOutlet weak var birthdayLabel: WKInterfaceLabel!

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        let contactsManager = ContactsManager()
        let contacts = contactsManager.loadContacts(1)
        
        if let contact = contacts.first {
            image.setImageData(contact.thumbnailImageData)
            nameLabel.setText(CNContactFormatter.stringFromContact(contact, style: .FullName))
            
            if let birthdayData = contact.birthdayData() {
                let formatter = NSDateFormatter()
                formatter.dateFormat = kBirthdayDateFormat
                
                birthdayLabel.setText("\(birthdayData.age) anni \(formatter.stringFromDate(birthdayData.nextBirthdayDate))")
            }
        }
    }

}
