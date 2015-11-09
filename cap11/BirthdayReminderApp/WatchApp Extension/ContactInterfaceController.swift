//
//  ContactInterfaceController.swift
//  BirthdayReminderApp
//
//  Created by Massimiliano Bigatti on 27/07/15.
//  Copyright © 2015 Massimiliano Bigatti. All rights reserved.
//

import WatchKit
import Foundation
import Contacts

class ContactInterfaceController: WKInterfaceController {

    @IBOutlet weak var table: WKInterfaceTable!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        if let contact = context as? CNContact {
            
            //
            // determine row types
            //
            var rowTypes = [ "ContactSummary" ]
            for _ in 0..<contact.phoneNumbers.count + contact.emailAddresses.count {
                rowTypes.append("ContactDetail")
            }
            if contact.postalAddresses.first != nil {
                rowTypes.append("ContactMap")
            }
            table.setRowTypes(rowTypes)
            
            //
            // populate data
            //
            populateSummary(contact)
            populateContactDetail(contact)
            populateMap(contact)
        }
    }
    
    private func populateSummary(contact: CNContact) {
        let summaryRow = table.rowControllerAtIndex(0) as! ContactSummaryRowController

        if let thumbnailImageData = contact.thumbnailImageData {
            summaryRow.setImageData(thumbnailImageData)
        }
        
        if let fullName = CNContactFormatter.stringFromContact(contact, style: .FullName) {
            summaryRow.setFullName(fullName)
        }
        
        if let birthdayData = contact.birthdayData() {
            summaryRow.setAge(birthdayData.age, onDate: birthdayData.nextBirthdayDate)
            summaryRow.setBirthday(birthdayData.birthdayDate)
        }
    }
    
    private func populateContactDetail(contact : CNContact) {
        var index = 1
        
        for phoneNumber in contact.phoneNumbers {
            let row = table.rowControllerAtIndex(index) as! ContactDetailRowController
            index++
            
            let pn = phoneNumber.value as! CNPhoneNumber
            
            row.setValue(pn.stringValue)
            row.setDescription(CNLabeledValue.localizedStringForLabel(phoneNumber.label))
        }
        
        for emailAddresss in contact.emailAddresses {
            let row = table.rowControllerAtIndex(index) as! ContactDetailRowController
            index++
            
            row.setValue(emailAddresss.value as! String)
            row.setDescription(CNLabeledValue.localizedStringForLabel(emailAddresss.label))
        }
    }
    
    private func populateMap(contact: CNContact) {
        //
        // locate address
        //
        if let postalAddress = contact.postalAddresses.first {
            let address = postalAddress.value as! CNPostalAddress
            let addressString = "\(address.street) \(address.postalCode) \(address.city) \(address.state) \(address.country)"
            
            print("locating address \(addressString)")
            
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(addressString, completionHandler: { (placemarks: [CLPlacemark]?, error: NSError?) -> Void in
                if error == nil {
                    if let placemark = placemarks?.first {
                        
                        //
                        // populate map
                        //
                        let index = self.table.numberOfRows - 1
                        let row = self.table.rowControllerAtIndex(index) as! ContactMapRowController
                        if let coordinate = placemark.location?.coordinate {
                            row.setCoordinate(coordinate)
                        }
                        
                    }
                } else {
                    print("Error while geofencing address \(error?.localizedDescription)")
                }
            })
        }
    }
}

