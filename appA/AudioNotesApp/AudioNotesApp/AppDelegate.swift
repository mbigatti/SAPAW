//
//  AppDelegate.swift
//  AudioNotesApp
//
//  Created by Massimiliano Bigatti on 17/10/15.
//  Copyright © 2015 Massimiliano Bigatti. All rights reserved.
//

import UIKit
import WatchConnectivity

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, WCSessionDelegate {

    var window: UIWindow?
    var session: WCSession?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        if WCSession.isSupported() {
            session = WCSession.defaultSession()
            session?.delegate = self
            session?.activateSession()

            // NSNotificationCenter.defaultCenter().addObserver(self, selector: "userDefaultsDidChange", name: NSUserDefaultsDidChangeNotification, object: nil)
            
            print("user default propagation ready")
            
            sendUserDefaults()
        }

        return true
    }
    
    /*
    func userDefaultsDidChange() {
        sendUserDefaults()
    }
    */
    
    func sendUserDefaults() {
        print("sendUserDefaults")
        
        guard session != nil else {
            return
        }
        guard session!.paired && session!.watchAppInstalled else {
            return
        }
        
        var defaults = [String: AnyObject]()
        
        for key in kUserDefaultKeys {
            let value = NSUserDefaults.standardUserDefaults().objectForKey(key)
            defaults[key] = value
        }
        
        do {
            try session!.updateApplicationContext(defaults)
            print("user defaults sent \(defaults)")
            
        } catch {
            print("error updating counterpart \(error)")
        }
    }
}

