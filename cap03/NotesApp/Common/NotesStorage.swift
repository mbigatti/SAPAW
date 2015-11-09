//
//  NotesStorage.swift
//  NotesApp
//
//  Created by Massimiliano Bigatti on 25/06/15.
//  Copyright © 2015 Massimiliano Bigatti. All rights reserved.
//

import Foundation


let kShortMaxTextContentPreviewLength = 15
let kLongMaxTextContentPreviewLength = 35
let kNoteItemLastUpdateDateKey = "lastUpdateDate"
let kNoteItemContentIDKey = "contentID"

/**
    La classe `NoteItem`rappresenta una nota all'interno dell'elenco delle note gestito
    dall'applicazione.

 */
public class NoteItem : NSObject, NSCoding {
    
    // MARK: - Properties
    
    public var lastUpdateDate: NSDate
    public var contentID: NSUUID?
    
    public var textContent: String? {
        get {
            do {
                return try NotesStorage.sharedInstance.loadNote(self)
                
            } catch {
                print("content not present for note \(contentID)")
                return ""
            }
        }
    }
    
    public var shortTextContentPreview: String? {
        get {
            return self.textContent?.substringToMaxLength(kShortMaxTextContentPreviewLength)
        }
    }
    
    public var longTextContentPreview: String? {
        get {
            return self.textContent?.substringToMaxLength(kLongMaxTextContentPreviewLength)
        }
    }

    // MARK: - Init
    
    required public init?(coder aDecoder: NSCoder) {
        lastUpdateDate = aDecoder.decodeObjectForKey(kNoteItemLastUpdateDateKey) as! NSDate
        contentID = aDecoder.decodeObjectForKey(kNoteItemContentIDKey) as? NSUUID
        
        super.init()
    }
    
    public init(contentID: NSUUID) {
        self.contentID = contentID
        self.lastUpdateDate = NSDate()
        
        super.init()
    }
    
    public func encodeWithCoder(encoder: NSCoder) {
        encoder.encodeObject(lastUpdateDate, forKey: kNoteItemLastUpdateDateKey)
        encoder.encodeObject(contentID, forKey: kNoteItemContentIDKey)
    }
    
}

extension String {
    func substringToMaxLength(maxLength: Int) -> String {
        if self.characters.count < maxLength {
            return self
            
        } else {
            let temp = self.substringToIndex(self.startIndex.advancedBy(maxLength))
            return "\(temp)..."
        }
    }
}

/**
    La classe `NotesStorage` rappresenta il database delle note gestito dall'applicazione.

 */
public class NotesStorage {
    static let sharedInstance = NotesStorage()
    
    static let filename = "notes.db"
    static let documentsURL =  NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0] as NSURL
    static var documentURL: NSURL = documentsURL.URLByAppendingPathComponent(filename)
    
    public var notes = [NoteItem]()
    
    public init() {
        print("Using database \(NotesStorage.documentURL)")
        
        load()
    }
    
    public func addNoteWithText(text: String) throws -> NoteItem {
        let uuid = NSUUID()

        try writeNoteWithUUID(uuid, andText: text)
        
        let item = NoteItem(contentID: uuid)
        notes.append(item)
        
        if save() {
            return item
        } else {
            throw NotesStorageError.UnableToAdd
        }
    }
    
    public func updateNoteItem(item: NoteItem, withText text: String) throws {
        item.lastUpdateDate = NSDate()
        
        try writeNoteWithUUID(item.contentID!, andText: text)
        
        if !save() {
            throw NotesStorageError.UnableToUpdate
        }
    }
    
    public func removeNoteItem(item: NoteItem) throws {
        let url = NotesStorage.URLforUUID(item.contentID!)
        
        try NSFileManager.defaultManager().removeItemAtURL(url)
        
        if let index = noteItemIndexWithUUID(item.contentID!) {
            notes.removeAtIndex(index)
        }
        
        if !save() {
            throw NotesStorageError.UnableToRemove
        }
    }
    
    func noteItemIndexWithUUID(uuid: NSUUID) -> Int? {
        for (index, currentItem) in notes.enumerate() {
            if currentItem.contentID?.UUIDString == uuid.UUIDString {
                return index
            }
        }
        return nil
    }
    
    
    // MARK: - Privates
    
    private func writeNoteWithUUID(uuid: NSUUID, andText text: String) throws -> Bool {
        try text.writeToFile(NotesStorage.URLforUUID(uuid).path!, atomically: true, encoding: NSUTF8StringEncoding)
        return true
    }
    
    private func loadNote(item: NoteItem) throws -> String? {
        let uuid = item.contentID!
        let url = NotesStorage.URLforUUID(uuid)
        return try NSString(contentsOfURL: url, encoding: NSUTF8StringEncoding) as String
    }
    
    
    // MARK: - Persistence
    
    internal func load() -> Bool {
        let data = NSData(contentsOfURL: NotesStorage.documentURL)
        
        guard let _data = data else {
            return false
        }
        
        do {
            notes = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(_data) as! [NoteItem]
            
        } catch {
            print("Unable to parse data")
            
            return false
        }
        
        return true
    }
    
    internal func save() -> Bool {
        let data = NSKeyedArchiver.archivedDataWithRootObject(notes)
        return data.writeToURL(NotesStorage.documentURL, atomically: true)
    }

    
    // MARK: - Helper Functions
    
    class func URLforUUID(id: NSUUID) -> NSURL {
        return documentsURL.URLByAppendingPathComponent(id.UUIDString)
    }
}

enum NotesStorageError: ErrorType {
    case UnableToAdd
    case UnableToUpdate
    case UnableToRemove
}

