//
//  ExtensionDelegate.swift
//  WatchApp Extension
//
//  Created by Massimiliano Bigatti on 25/06/15.
//  Copyright © 2015 Massimiliano Bigatti. All rights reserved.
//

import WatchKit
import WatchConnectivity

let kDidReceiveNoteDataNotification = "kDidReceiveNoteDataNotification"

class ExtensionDelegate: NSObject, WKExtensionDelegate, WCSessionDelegate {
    
    var session : WCSession!

    func applicationDidFinishLaunching() {
        if WCSession.isSupported() {
            session = WCSession.defaultSession()
            session.delegate = self
            session.activateSession()
            
            requestApplicationContext()
        }
    }
    
    
    // MARK: - Synchronizer
    
    /**
        Request application context to master (Watch request to iPhone)
     */
    func requestApplicationContext() {
        print("requestApplicationContext(), supported=\(WCSession.isSupported()), reachable=\(session.reachable)")
        
        if WCSession.isSupported() {
            let message = [kContextRequestMessageKey: ""]
            
            session.sendMessage(message, replyHandler: nil) { (error: NSError) -> Void in
                print("error while requesting application context \(message) \(error)")
            }
        }
        
    }
    
    /**
        Request content to counterpart
     */
    func requestNoteItemContent(item: NoteItem) {
        print("requesting content to counterpart")
        
        var message = [String: AnyObject]()
        message[kContentRequestMessageKey] = item.contentID!.UUIDString
        
        session.sendMessage(message, replyHandler: nil) { (error) -> Void in
            print("error while sending message \(message) \(error)")
        }
    }
    
    
    //
    // MARK: - WCSessionDelegate
    //
    
    /**
        Received context update from counterpart
     */
    func session(session: WCSession, didReceiveApplicationContext applicationContext: [String : AnyObject]) {
        print("received context update from counterpart")
        
        let items = applicationContext[kNoteStorageRootKey] as! [AnyObject]
        print("context has \(items.count) notes")
        
        let notesStorage = NotesStorage.sharedInstance
        
        for item in items {
            let _item = item as! [String: AnyObject]
            
            let lastUpdateDate = _item[kNoteItemLastUpdateDateKey] as! NSDate
            let contentID = NSUUID(UUIDString: _item[kNoteItemContentIDKey] as! String)
            
            if let index = notesStorage.noteItemIndexWithUUID(contentID!) {
                // update existing item
                let noteItem = notesStorage.notes[index]
                if noteItem.lastUpdateDate != lastUpdateDate {
                    print("updating note \(contentID!) [\(lastUpdateDate) \(noteItem.lastUpdateDate)]")
                    
                    noteItem.lastUpdateDate = lastUpdateDate
                    NotesStorage.sharedInstance.save()
                    
                    requestNoteItemContent(noteItem)
                }
            } else {
                // create new item
                let noteItem = NoteItem(contentID: contentID!)
                NotesStorage.sharedInstance.notes.append(noteItem)
                NotesStorage.sharedInstance.save()
                
                requestNoteItemContent(noteItem)
            }
        }
        
        //
        // remove deleted notes
        //
        do {
            for noteItem in notesStorage.notes {
                let elements = items.filter() {
                    let _item = $0 as! [String: AnyObject]
                    let contentID = NSUUID(UUIDString: _item[kNoteItemContentIDKey] as! String)
                    return contentID == noteItem.contentID
                }
                if elements.count == 0 {
                    try NotesStorage.sharedInstance.removeNoteItem(noteItem)
                }
            }
        } catch {
            print("error removing old notes \(error)")
        }
        
        NSNotificationCenter.defaultCenter().postNotificationName(kDidReceiveNoteDataNotification, object: nil)
    }
    
    /**
        Received file from counterpart when application is closed
     */
    func session(session: WCSession, didReceiveFile file: WCSessionFile) {
        moveFileToFinalLocation(file)
    }
    
    /**
        Received file from counterpart when application is opened
     */
    func session(session: WCSession, didFinishFileTransfer fileTransfer: WCSessionFileTransfer, error: NSError?) {
        print("received file from counterpart when application is opened, error=\(error)")
        
        if error == nil {
            moveFileToFinalLocation(fileTransfer.file)
            
        } else {
            print("error receiving file \(error)")
        }
    }
    
    
    // MARK: - Privates
    
    /**
        Move file received from counterpart from temporary location to final one
     */
    private func moveFileToFinalLocation(file: WCSessionFile) {
        let uuidString = file.metadata?[kContentRequestMessageKey] as? String
        if let uuid = uuidString {
            let destinationURL = NotesStorage.URLforUUID(NSUUID(UUIDString: uuid)!)
            do {
                print("moving \(file.fileURL) to \(destinationURL)")
                
                let fileManager = NSFileManager.defaultManager()
                
                if let path = destinationURL.path {
                    if fileManager.fileExistsAtPath(path) {
                        try fileManager.removeItemAtURL(destinationURL)
                    }
                }
                
                try fileManager.moveItemAtURL(file.fileURL, toURL: destinationURL)
                
                NSNotificationCenter.defaultCenter().postNotificationName(kDidReceiveNoteDataNotification, object: uuid)
                
            } catch {
                print("Unable to move file in final location \(error)")
            }
        }
    }

}
