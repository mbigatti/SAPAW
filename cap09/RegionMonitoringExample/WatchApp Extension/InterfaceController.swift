//
//  InterfaceController.swift
//  WatchApp Extension
//
//  Created by Massimiliano Bigatti on 30/07/15.
//  Copyright © 2015 Massimiliano Bigatti. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity


class InterfaceController: WKInterfaceController, WCSessionDelegate {

    @IBOutlet var arrivedLabel: WKInterfaceLabel!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        let session = WCSession.defaultSession()
        session.delegate = self
        session.activateSession()
    }

    func session(session: WCSession, didReceiveMessage message: [String : AnyObject]) {
        print("message received \(message)")
        
        if let key = message[kEventMessageKey] as? String {
            switch key {
            case kDidEnterRegionMessageValue:
                arrivedLabel.setHidden(false)
                
            case kDidExitRegionMessageValue:
                arrivedLabel.setHidden(true)
                
            default:
                break
            }
        }
    }
}
