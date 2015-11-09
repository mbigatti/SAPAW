//
//  ExtensionDelegate.swift
//  WatchApp Extension
//
//  Created by Massimiliano Bigatti on 18/06/15.
//  Copyright © 2015 Massimiliano Bigatti. All rights reserved.
//

import WatchKit


class ExtensionDelegate: NSObject, WKExtensionDelegate {
    
    func didReceiveLocalNotification(notification: UILocalNotification) {
        print("didReceiveLocalNotification")
        
        if let rootController = WKExtension.sharedExtension().rootInterfaceController as? InterfaceController {
            rootController.timerEnded()
        }
    }
    
    func handleActionWithIdentifier(identifier: String?, forLocalNotification localNotification: UILocalNotification) {
        print("WKExtensionDelegate.handleActionWithIdentifier:forLocalNotification identifier = \(identifier)")
    }
    
    func handleActionWithIdentifier(identifier: String?, forRemoteNotification remoteNotification: [NSObject : AnyObject]) {
        print("WKExtensionDelegate.handleActionWithIdentifier:remoteNotification identifier = \(identifier)")
    }
}
