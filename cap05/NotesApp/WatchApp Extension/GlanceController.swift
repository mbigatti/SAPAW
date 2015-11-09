//
//  GlanceController.swift
//  WatchApp Extension
//
//  Created by Massimiliano Bigatti on 17/07/15.
//  Copyright © 2015 Massimiliano Bigatti. All rights reserved.
//

import WatchKit
import Foundation

class GlanceController: WKInterfaceController {
    
    @IBOutlet weak var notesCountLabel: WKInterfaceLabel!
    @IBOutlet weak var noteLabel: WKInterfaceLabel!

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
     
        let notes = NotesStorage.sharedInstance.notes
        notesCountLabel.setText("\(notes.count)")
        
        if let lastNote = notes.last {
            noteLabel.setText(lastNote.textContent)
            
            if let uuidString = lastNote.contentID?.UUIDString {
                updateUserActivity(kHandoffActivityNoteDetail, userInfo: [kHandoffNoteID: uuidString], webpageURL: nil)
            }
            
        } else {
            noteLabel.setText("")
        }
    }

}
