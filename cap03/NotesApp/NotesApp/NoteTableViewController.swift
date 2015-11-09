//
//  ViewController.swift
//  NotesApp
//
//  Created by Massimiliano Bigatti on 25/06/15.
//  Copyright © 2015 Massimiliano Bigatti. All rights reserved.
//

import UIKit

class NoteTableViewController: UITableViewController {
    let dateFormatter = NSDateFormatter()

    
    // MARK: - UITableViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateFormat = "dd-MM-yy hh:mm"
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.tableView.reloadData()
    }
    
    
    // MARK: - UITableViewDataSource
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NotesStorage.sharedInstance.notes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell!
        let noteItem = NotesStorage.sharedInstance.notes[indexPath.row]
        
        cell.textLabel?.text = noteItem.longTextContentPreview
        cell.detailTextLabel?.text = dateFormatter.stringFromDate(noteItem.lastUpdateDate)
        
        return cell
    }
    
    
    // MARK: - UITableViewDelegate
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            do {
                let noteItem = NotesStorage.sharedInstance.notes[indexPath.row]
                try NotesStorage.sharedInstance.removeNoteItem(noteItem)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                
                if let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate {
                    appDelegate.sendApplicationContext()
                }
                
            } catch {
                UIAlertController.presentPersistenceErrorAlert(self)
            }
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("edit", sender: NotesStorage.sharedInstance.notes[indexPath.row])
    }
    
    
    // MARK: - UITableViewController
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let controller = segue.destinationViewController as! NoteDetailViewController
        controller.noteItem = sender as? NoteItem
    }
    
}

