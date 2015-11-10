//
//  MainInterfaceController.swift
//  WatchApp Extension
//
//  Created by Massimiliano Bigatti on 17/10/15.
//  Copyright © 2015 Massimiliano Bigatti. All rights reserved.
//

import Foundation
import WatchKit
import WatchConnectivity


let kAppTitle = "Note Audio"
let kAudioClipDataFormat = "d/M hh:mm"

class MainInterfaceController: WKInterfaceController, WCSessionDelegate {
    let containerURL =  NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier("group.it.bigatti.samples.AudioNoteApp")!
    let audioClipFileExtension = "mp4"
    
    @IBOutlet var table: WKInterfaceTable!
    @IBOutlet var recordButton: WKInterfaceButton!
    @IBOutlet var playAllButton: WKInterfaceButton!
    @IBOutlet var deleteButton: WKInterfaceButton!
        
    var audioClipDataArray = [AudioClipData]()
    var session : WCSession?
    
    //
    // MARK: - WKInterfaceController
    //
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        self.setTitle(kAppTitle)

        let userDefaults = NSUserDefaults.standardUserDefaults()
        if userDefaults.registrationPreset() == nil {
            print("watch preferences not set, enabling defaults")
            var index = 0
            for key in kUserDefaultKeys {
                userDefaults.setObject(kUserDefaultValues[index++], forKey: key)
            }
        }
        
        if WCSession.isSupported() {
            session = WCSession.defaultSession()
            session!.delegate = self
            session!.activateSession()
        }
        
        loadAudioClips()
        populateTable()
        
        updateUI()
    }
    
    override func table(table: WKInterfaceTable, didSelectRowAtIndex rowIndex: Int) {
        print("playing \(audioClipDataArray[rowIndex].url)")
        
        if let url = audioClipDataArray[rowIndex].url {
            presentMediaPlayerControllerWithURL(url, options: [WKMediaPlayerControllerOptionsAutoplayKey : true], completion: { (didPlayToEnd, endTime, error) -> Void in
                if error != nil {
                    print("Error while playing clip \(error)")
                }
            })
        }
    }
    
    
    //
    // MARK: Actions
    //
    
    @IBAction func recordButtonTapped() {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd_HH-mm-ss"
        
        let filename = "\(dateFormatter.stringFromDate(NSDate())).\(audioClipFileExtension)"
        let localUrl = containerURL.URLByAppendingPathComponent(filename)
        let options : [NSObject: AnyObject] = [
            WKAudioRecorderControllerOptionsMaximumDurationKey: NSUserDefaults.standardUserDefaults().registrationDuration(),
            WKAudioRecorderControllerOptionsActionTitleKey:     "Conferma"
        ]
        
        print("saving to url \(localUrl)")
        
        presentAudioRecorderControllerWithOutputURL(localUrl,
            preset: NSUserDefaults.standardUserDefaults().registrationPreset()!,
            options: options) { (didSave: Bool, error: NSError?) -> Void in
                if error != nil {
                    let defaultAction = WKAlertAction(title: "OK", style: .Default) {}
                    self.presentAlertControllerWithTitle(kAppTitle, message: "Errore in fase di registrazione \(error?.localizedDescription)", preferredStyle: .Alert, actions: [defaultAction])
                }
                if didSave {
                    print("audio clip saved")
                    
                    let audioClipData = AudioClipData(url: localUrl)
                    self.audioClipDataArray.append(audioClipData)
                    
                    self.addClipToTable(audioClipData)
                }
        }
    }
    
    @IBAction func playAllButtonButtonTapped() {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = kAudioClipDataFormat
        
        var playerItemArray = [WKAudioFilePlayerItem]()
        
        for audioClipData in audioClipDataArray {
            let asset = WKAudioFileAsset(URL: audioClipData.url!, title: dateFormatter.stringFromDate(audioClipData.date!), albumTitle: nil, artist: nil)
            let playerItem = WKAudioFilePlayerItem(asset: asset)
            playerItemArray.append(playerItem)
        }

        presentControllerWithName("Playback", context: playerItemArray)
    }
    
    @IBAction func deleteButtonTapped() {
        let deleteAction = WKAlertAction(title: "Cancella", style: .Destructive) {
            do {
                let fileManager = NSFileManager.defaultManager()
                let fileURLArray = try fileManager.contentsOfDirectoryAtURL(self.containerURL, includingPropertiesForKeys: nil,
                    options: [])
                
                print("checking for delete \(fileURLArray.count) files")
                
                for fileURL in fileURLArray {
                    if fileURL.pathExtension == self.audioClipFileExtension {
                        print("deleting \(fileURL)")
                        try fileManager.removeItemAtURL(fileURL)
                    }
                }
                
                self.audioClipDataArray.removeAll()
                self.table.setNumberOfRows(0, withRowType: "")
                self.playAllButton.setEnabled(false)
                self.deleteButton.setEnabled(false)
                
            } catch {
                print("error deleting files \(error)")
            }
        }
        let cancelAction = WKAlertAction(title: "Annulla", style: .Default) {}
        presentAlertControllerWithTitle(kAppTitle, message: "Confermi la cancellazione di tutte le note?", preferredStyle: .SideBySideButtonsAlert, actions: [deleteAction, cancelAction])

    }
    
    
    //
    // MARK: - Watch Connectivity
    //
    
    func session(session: WCSession, didReceiveApplicationContext applicationContext: [String : AnyObject]) {
        print("received user defaults \(applicationContext)")
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        for key in applicationContext.keys {
            let value = applicationContext[key]
            userDefaults.setObject(value, forKey: key)
        }
        
        updateUI()
    }
    
    
    //
    // MARK: - Privates
    //
    
    private func updateUI() {
        deleteButton.setHidden(!NSUserDefaults.standardUserDefaults().enableDeletion())
    }
    
    private func loadAudioClips() {
        do {
            let rawFileURLArray = try NSFileManager.defaultManager().contentsOfDirectoryAtURL(containerURL, includingPropertiesForKeys: nil,
                options: [])
            
            let filteredFileURLArray = rawFileURLArray.filter({ (fileURL:NSURL) -> Bool in
                return fileURL.pathExtension == audioClipFileExtension
            })
            let sortedFileURLArray = filteredFileURLArray.sort({ (url1: NSURL, url2: NSURL) -> Bool in
                return url1.lastPathComponent?.compare(url2.lastPathComponent!) == .OrderedAscending
            })
            
            for fileURL: NSURL in sortedFileURLArray {
                audioClipDataArray.append(AudioClipData(url: fileURL))
            }
            
            print("there are \(audioClipDataArray.count) audio clip in container directory \(containerURL)")
            
        } catch {
            print("error getting local documents directory listing \(error)")
        }
    }
    
    private func populateTable() {
        for audioClipData in audioClipDataArray {
            addClipToTable(audioClipData)
        }
    }
    
    private func addClipToTable(audioClipData: AudioClipData) {
        let rows = NSMutableIndexSet()
        rows.addIndex(table.numberOfRows)
        table.insertRowsAtIndexes(rows, withRowType: "AudioRowController")
        
        let row = table.rowControllerAtIndex(table.numberOfRows - 1) as! AudioRowController
        row.setDate(audioClipData.date)
        row.setDuration(audioClipData.duration)
        
        playAllButton.setEnabled(true)
        deleteButton.setEnabled(true)
    }
    
}

