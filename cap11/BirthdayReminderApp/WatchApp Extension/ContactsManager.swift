//
//  ContactsManager.swift
//  BirthdayReminderApp
//
//  Created by Massimiliano Bigatti on 27/07/15.
//  Copyright © 2015 Massimiliano Bigatti. All rights reserved.
//

import Foundation
import Contacts

class ContactsManager {
    let contactStore = CNContactStore()

    func loadContacts(limit: Int) -> [CNContact] {
        var contacts = [CNContact]()
        
        do {            
            let keys = [
                // required for full name
                CNContactNamePrefixKey,
                CNContactNameSuffixKey,
                CNContactGivenNameKey,
                CNContactMiddleNameKey,
                CNContactFamilyNameKey,
                CNContactTypeKey,
                
                //CNContactImageDataKey,
                CNContactThumbnailImageDataKey,
                
                CNContactPhoneNumbersKey,
                CNContactEmailAddressesKey,
                CNContactBirthdayKey,
                CNContactPostalAddressesKey,
            ]
            
            /*
            let predicate = CNContact.predicateForContactsWithIdentifiers(keys)
            let allContacts = try contactStore.unifiedContactsMatchingPredicate(predicate, keysToFetch: keys)
            print("total contacts \(allContacts.count)")
            */

            let request = CNContactFetchRequest(keysToFetch: keys)
            try contactStore.enumerateContactsWithFetchRequest(request, usingBlock: { (contact: CNContact, stop: UnsafeMutablePointer<ObjCBool>) -> Void in
                // print("\(contact.familyName)")
                
                if contact.birthday != nil {
                    contacts.append(contact)
                }
            })
            
            //
            // test data
            //
            /*
            let creator = ContactsCreator()
            contacts = [CNContact]()
            contacts.append(creator.createContact1())
            contacts.append(creator.createContact2())
            contacts.append(creator.createContact3())
            */
            
            print("loaded \(contacts.count) contacts")
            
            //
            // sort contacts by birth date
            //
            contacts.sortInPlace({
                if $0.birthday?.month == $1.birthday?.month {
                    return $0.birthday?.day < $1.birthday?.day
                } else {
                    return $0.birthday?.month < $1.birthday?.month
                }
            })

            //
            // limit result to the first n elements of the array, as requested
            //
            if limit > 0 {
                contacts = Array(contacts[0...min(contacts.count - 1, limit - 1)])
            }
            print("limited to \(contacts.count) contacts")
            
            //
            // shift contacts to present first the upcoming one
            //
            var shiftedContacts = [CNContact]()
            let todayComponents = NSCalendar.currentCalendar().components([.Day, .Month], fromDate: NSDate())
            var firstIndex : Int?
            for index in 0..<contacts.count {
                let contact = contacts[index]
                if contact.birthday?.month == todayComponents.month {
                    if contact.birthday?.day > todayComponents.day {
                        firstIndex = index
                        break
                    }
                } else {
                    if contact.birthday?.month > todayComponents.month {
                        firstIndex = index
                        break
                    }
                }
            }
            if firstIndex != nil {
                for var index = firstIndex!; index < contacts.count; index++ {
                    shiftedContacts.append(contacts[index])
                }
                for var index = 0; index < firstIndex!; index++ {
                    shiftedContacts.append(contacts[index])
                }
                contacts = shiftedContacts
            }
            
        } catch {
            print("unable to fetch contacts from address book")
        }
        
        return contacts
    }
    
}