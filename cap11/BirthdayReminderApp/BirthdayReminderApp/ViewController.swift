//
//  ViewController.swift
//  BirthdayReminderApp
//
//  Created by Massimiliano Bigatti on 17/07/15.
//  Copyright © 2015 Massimiliano Bigatti. All rights reserved.
//

import UIKit
import Contacts

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        /*
        let contactStore = CNContactStore()
        var contacts = [CNContact]()

        if CNContactStore.authorizationStatusForEntityType(.Contacts) == .NotDetermined {
            let store = CNContactStore()
            
            store.requestAccessForEntityType(CNEntityType.Contacts, completionHandler: { (granted: Bool, error: NSError?) -> Void in
                if error != nil {
                    print("Error while requesting access to Contacts \(error)")
                }
                print(granted ? "Contacts access granted" : "Contacts access denied")
            })
        }
        
        //
        // test
        //
        do {
            let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey, CNContactBirthdayKey]
            let request = CNContactFetchRequest(keysToFetch: keys)
            try contactStore.enumerateContactsWithFetchRequest(request, usingBlock: { (contact: CNContact, stop: UnsafeMutablePointer<ObjCBool>) -> Void in
                
                if contact.birthday != nil {
                    self.contacts.append(contact)
                }
            })
            
            print("loaded \(contacts.count) contacts")
            
        } catch {
            print("unable to fetch contacts from address book")
        }
        */
        
    }


}

