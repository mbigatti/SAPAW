//
//  NoteDetailViewController.swift
//  NotesApp
//
//  Created by Massimiliano Bigatti on 25/06/15.
//  Copyright © 2015 Massimiliano Bigatti. All rights reserved.
//

import UIKit

class NoteDetailViewController : UIViewController {
    
    @IBOutlet weak var noteTextView: UITextView!
    
    var noteItem : NoteItem?

    
    //
    // MARK: - UIViewController
    //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        noteTextView.text = noteItem?.textContent
        noteTextView.becomeFirstResponder()
    }
    
    
    // MARK: - Actions
    
    @IBAction func doneButtonTapped(sender: UIBarButtonItem) {
        do {
            if let item = noteItem {
                try NotesStorage.sharedInstance.updateNoteItem(item, withText: noteTextView.text)
                
                if let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate {
                    appDelegate.sendNoteItemContentWithUUID(item.contentID!)
                }
                
            } else {
                if noteTextView.text.characters.count != 0 {
                    try NotesStorage.sharedInstance.addNoteWithText(noteTextView.text)
                    
                    if let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate {
                        appDelegate.sendApplicationContext()
                    }
                    
                }
            }
            
            self.navigationController?.popViewControllerAnimated(true)
            
        } catch {
            UIAlertController.presentPersistenceErrorAlert(self)
        }
        
    }
    
}
