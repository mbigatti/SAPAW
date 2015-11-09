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
    
    /**
        Sends note content to counterpart
     */
    func sendNoteItemContentWithUUID(uuid: NSUUID) {
        let url = NotesStorage.URLforUUID(uuid)
        session.transferFile(url, metadata: [kContentRequestMessageKey: uuid.UUIDString])
    }
    
}

