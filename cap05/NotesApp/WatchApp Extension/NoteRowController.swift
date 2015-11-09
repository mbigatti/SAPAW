//
//  NoteRowController.swift
//  NotesApp
//
//  Created by Massimiliano Bigatti on 13/07/15.
//  Copyright © 2015 Massimiliano Bigatti. All rights reserved.
//

import WatchKit

class NoteRowController : NSObject {
    
    @IBOutlet weak var label: WKInterfaceLabel!
    
    var oldNotePreview : String?
    
    func setNotePreview(notePreview: String) {
        if notePreview != oldNotePreview {
            oldNotePreview = notePreview
            label.setText(notePreview)
        }
    }
    
}
