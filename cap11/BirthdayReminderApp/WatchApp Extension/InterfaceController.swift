//
//  InterfaceController.swift
//  WatchApp Extension
//
//  Created by Massimiliano Bigatti on 17/07/15.
//  Copyright © 2015 Massimiliano Bigatti. All rights reserved.
//

import WatchKit
import Foundation
import Contacts

class InterfaceController: WKInterfaceController {
    
    @IBOutlet var label: WKInterfaceLabel!
    
    let contactStore = CNContactStore()
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        requestContactsAuthorization()
    }
    
    private func requestContactsAuthorization() {
        switch CNContactStore.authorizationStatusForEntityType(CNEntityType.Contacts) {
        case .NotDetermined:
            self.contactStore.requestAccessForEntityType(CNEntityType.Contacts, completionHandler: { (granted: Bool, error: NSError?) -> Void in
                if error == nil {
                    if granted {
                        self.loadContacts()
                    } else {
                        print("Contacts access denied")
                    }
                } else {
                    print("Error while requesting access to Contacts \(error)")
                }
            })
            
        case .Authorized:
            loadContacts()
            
        default:
            // app disabled
            break
        }
    }
    
    private func loadContacts() {
        print("loadContacts()")

        let contactsManager = ContactsManager()
        let contacts = contactsManager.loadContacts(-1)
        
        var controllerNames = [String]()
        for _ in contacts {
            controllerNames.append("ContactController")
        }
        
        if controllerNames.count == 0 {
            label.setText("Nessun contatto con compleanno individuato")
        } else {
            WKInterfaceController.reloadRootControllersWithNames(controllerNames, contexts: contacts)
        }
    }

}
