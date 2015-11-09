//
//  NoteDetailInterfaceController.swift
//  NotesApp
//
//  Created by Massimiliano Bigatti on 28/07/15.
//  Copyright © 2015 Massimiliano Bigatti. All rights reserved.
//

import Foundation

import WatchKit
import Foundation


class NoteDetailInterfaceController: WKInterfaceController {
    
    @IBOutlet var label: WKInterfaceLabel!
    var noteItem: NoteItem?
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didReceiveNoteDataNotification:", name: kDidReceiveNoteDataNotification, object: nil)

        noteItem = context as? NoteItem
        
        if let _noteItem = noteItem {
            label.setText(_noteItem.textContent)
            
            updateUserActivity(kHandoffActivityNoteDetail, userInfo: [kHandoffNoteID: _noteItem.contentID!.UUIDString], webpageURL: nil)
        }
    }
    
    override func didDeactivate() {
        super.didDeactivate()
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
        invalidateUserActivity()
    }
    
    @objc func didReceiveNoteDataNotification(notification: NSNotification) {
        label.setText(noteItem?.textContent)
    }
}
