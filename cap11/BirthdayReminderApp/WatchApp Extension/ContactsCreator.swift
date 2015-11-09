//
//  ContactsCreator.swift
//  FitnessApp
//
//  Created by Massimiliano Bigatti on 17/07/15.
//  Copyright © 2015 Massimiliano Bigatti. All rights reserved.
//

import Foundation
import WatchKit
import Contacts

class ContactsCreator {

    /*
    func populateAddressBook() throws {
        let contact = createContact()
    }
    
    func saveContact(contact: CNContact) throws {
        let store = CNContactStore()
        //let saveRequest = CNSaveRequest()
        
        //saveRequest.addContact(contact, toContainerWithIdentifier:nil)
        //try store.executeSaveRequest(saveRequest)
    }
    */
    
    func createContact1() -> CNContact {
        let contact = CNMutableContact()
        
        //
        // personal data
        //
        contact.givenName = "Mario"
        contact.familyName = "Rossi"
        if let image = UIImage(named: "person1") {
            contact.imageData = UIImageJPEGRepresentation(image, 1.0)
        }
        
        //
        // email
        //
        let homeEmail = CNLabeledValue(label: CNLabelHome, value: "mario.rossi@example.com")
        contact.emailAddresses = [homeEmail]
        
        //
        // phones
        //
        let personalPhone = CNLabeledValue(label: CNLabelPhoneNumberiPhone, value: CNPhoneNumber(stringValue:"333 0000-0000"))
        let homePhone = CNLabeledValue(label: CNLabelPhoneNumberMain, value: CNPhoneNumber(stringValue:"02 0000-0000"))
        contact.phoneNumbers = [personalPhone, homePhone]

        //
        // home address
        //
        let homeAddress = CNMutablePostalAddress()
        homeAddress.street = "Via Orefici, 2"
        homeAddress.city = "Milano"
        homeAddress.country = "Italia"
        homeAddress.postalCode = "20123"
        contact.postalAddresses = [CNLabeledValue(label: CNLabelHome, value: homeAddress)]
        
        //
        // instant message
        //
        let instantMessage = CNInstantMessageAddress(username: "mrossi", service: CNInstantMessageServiceSkype)
        contact.instantMessageAddresses = [CNLabeledValue(label: "Skype", value: instantMessage)]
        
        //
        // birthday
        //
        let birthday = NSDateComponents()
        birthday.day = 1
        birthday.month = 7
        birthday.year = 1984
        contact.birthday = birthday
        
        // try CNContactVCardSerialization.dataWithContacts([contact])
 
        return contact
    }
    
    func createContact2() -> CNContact {
        let contact = CNMutableContact()
        
        //
        // personal data
        //
        contact.givenName = "Giovanni"
        contact.familyName = "Verdi"
        if let image = UIImage(named: "person2") {
            contact.imageData = UIImageJPEGRepresentation(image, 1.0)
        }
        
        //
        // email
        //
        let homeEmail = CNLabeledValue(label: CNLabelHome, value: "giovanni.verdi@example.com")
        contact.emailAddresses = [homeEmail]
        
        //
        // phones
        //
        let personalPhone = CNLabeledValue(label: CNLabelPhoneNumberiPhone, value: CNPhoneNumber(stringValue:"333 0000-0000"))
        let homePhone = CNLabeledValue(label: CNLabelPhoneNumberMain, value: CNPhoneNumber(stringValue:"02 0000-0000"))
        contact.phoneNumbers = [personalPhone, homePhone]
        
        //
        // birthday
        //
        let birthday = NSDateComponents()
        birthday.day = 3
        birthday.month = 9
        birthday.year = 1977
        contact.birthday = birthday
        
        // try CNContactVCardSerialization.dataWithContacts([contact])
        
        return contact
    }
    
    func createContact3() -> CNContact {
        let contact = CNMutableContact()
        
        //
        // personal data
        //
        contact.givenName = "Maria"
        contact.familyName = "Ferrari"
        if let image = UIImage(named: "person3") {
            contact.imageData = UIImageJPEGRepresentation(image, 1.0)
        }
        
        //
        // phones
        //
        let personalPhone = CNLabeledValue(label: CNLabelPhoneNumberMobile, value: CNPhoneNumber(stringValue:"333 0000-0000"))
        let homePhone = CNLabeledValue(label: CNLabelPhoneNumberMain, value: CNPhoneNumber(stringValue:"02 0000-0000"))
        contact.phoneNumbers = [personalPhone, homePhone]
        
        //
        // birthday
        //
        let birthday = NSDateComponents()
        birthday.day = 23
        birthday.month = 3
        birthday.year = 1974
        contact.birthday = birthday
        
        // try CNContactVCardSerialization.dataWithContacts([contact])
        
        return contact
    }
    
}