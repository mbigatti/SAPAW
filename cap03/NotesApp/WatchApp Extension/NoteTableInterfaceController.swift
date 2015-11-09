//
//  NoteTableInterfaceController.swift
//  NotesApp
//
//  Created by Massimiliano Bigatti on 13/07/15.
//  Copyright © 2015 Massimiliano Bigatti. All rights reserved.
//

import WatchKit
import Foundation


class NoteTableInterfaceController: WKInterfaceController {
    
    @IBOutlet var table: WKInterfaceTable!
    
    
    //
    // MARK: - WKInterfaceController
    //
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didReceiveNoteDataNotification:", name: kDidReceiveNoteDataNotification, object: nil)
        
        reloadTable()
    }
    
    override func didDeactivate() {
        super.didDeactivate()
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    override func table(table: WKInterfaceTable, didSelectRowAtIndex rowIndex: Int) {
        self.pushControllerWithName("NoteDetail", context: NotesStorage.sharedInstance.notes[rowIndex])
    }
    
    
    // MARK: - Notifications
    
    @objc func didReceiveNoteDataNotification(notification: NSNotification) {
        reloadTable()
    }
    
    
    // MARK: - Privates
    
    func reloadTable() {
        table.setNumberOfRows(NotesStorage.sharedInstance.notes.count, withRowType: "NoteRow")
        
        for (var i = 0; i < table.numberOfRows; i++) {
            let controller = self.table.rowControllerAtIndex(i) as! NoteRowController
            let noteItem = NotesStorage.sharedInstance.notes[i]
            
            controller.setNotePreview(noteItem.shortTextContentPreview!)
        }
    }
    
}
