//
//  AppDelegate.swift
//  NotesApp
//
//  Created by Massimiliano Bigatti on 25/06/15.
//  Copyright © 2015 Massimiliano Bigatti. All rights reserved.
//

import UIKit
import WatchConnectivity

let kAppTitle = "NotesApp"
let kPersistenceErrorMessage = "Errore in fase di salvataggio dei dati"
let kOKButtonTitle = "OK"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, WCSessionDelegate {

    var window: UIWindow?
    var session : WCSession!

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        // try synching the Watch
        
        if WCSession.isSupported() {
            session = WCSession.defaultSession()
            session.delegate = self
            session.activateSession()
            
            sendApplicationContext()
        }
        
        return true
    }
    
    
    // MARK: - Handoff
    
    func application(application: UIApplication, willContinueUserActivityWithType userActivityType: String) -> Bool {
        print("willContinueUserActivityWithType \(userActivityType)")
        return userActivityType == kHandoffActivityNoteDetail
    }
    
    func application(application: UIApplication, continueUserActivity userActivity: NSUserActivity, restorationHandler: ([AnyObject]?) -> Void) -> Bool {
        print("continueUserActivity \(userActivity)")
        
        if userActivity.activityType == kHandoffActivityNoteDetail {
            if let rootViewController = self.window?.rootViewController as! UINavigationController? {
                if let controller = rootViewController.topViewController {
                    restorationHandler([controller])
                }
            }
            
            return true
        }
        
        return false
    }
    
    func application(application: UIApplication, didFailToContinueUserActivityWithType userActivityType: String, error: NSError) {
        print("didFailToContinueUserActivityWithType \(error)")
    }

    
    // MARK: - Privates
    
    /**
        Initiate synching with counterpart sending application context
     */
    func sendApplicationContext() {
        print("sendApplicationContext(), installed=\(session.watchAppInstalled), paired=\(session.paired), reachable=\(session.reachable)")
        
        if session.watchAppInstalled && session.paired {
            do {
                var context = [String: AnyObject]()
                var items = [AnyObject]()
                
                for noteItem in NotesStorage.sharedInstance.notes {
                    var item = [String: AnyObject]()
                    
                    item[kNoteItemLastUpdateDateKey] = noteItem.lastUpdateDate
                    item[kNoteItemContentIDKey] = noteItem.contentID?.UUIDString
                    
                    items.append(item)
                }
                
                context[kNoteStorageRootKey] = items
                
                try session.updateApplicationContext(context)
                
            } catch {
                print("unable to send application context to Watch \(error)")
            }
        }
    }
    
    
    // MARK: - WCSessionDelegate
    
    /**
        Received message from the Watch. It could be:
    
        1. application context
        2. a specific note content
     */
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject]) {
        print("request content received from Watch [\(message)]")
        
        if message[kContextRequestMessageKey] != nil {
            sendApplicationContext()
        }
        
        if message[kContentRequestMessageKey] != nil {
            let uuidString = message[kContentRequestMessageKey] as! String
            sendNoteItemContentWithUUID(NSUUID(UUIDString: uuidString)!)
        }
    }
    /*
    func session(session: WCSession, didReceiveUserInfo userInfo: [String : AnyObject]) {
        print("request content received from Watch [\(userInfo)]")
        
        if userInfo[kContextRequestMessageKey] != nil {
            sendApplicationContext()
        }
        
        if userInfo[kContentRequestMessageKey] != nil {
            let uuidString = userInfo[kContentRequestMessageKey] as! String
            sendNoteItemContentWithUUID(NSUUID(UUIDString: uuidString)!)
        }
    }
    */
    
    /**
        Sends note content to counterpart
     */
    func sendNoteItemContentWithUUID(uuid: NSUUID) {
        let url = NotesStorage.URLforUUID(uuid)
        session.transferFile(url, metadata: [kContentRequestMessageKey: uuid.UUIDString])
    }
    
}

