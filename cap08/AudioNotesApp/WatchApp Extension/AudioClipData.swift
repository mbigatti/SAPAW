//
//  AudioClipData.swift
//  AudioNotesApp
//
//  Created by Massimiliano Bigatti on 18/10/15.
//  Copyright © 2015 Massimiliano Bigatti. All rights reserved.
//

import Foundation
import WatchKit

class AudioClipData {
    var url : NSURL? {
        didSet {
            loadAttributes()
        }
    }
    var date: NSDate?
    var duration: NSTimeInterval?
    
    init(url: NSURL?) {
        self.url = url
        loadAttributes()
    }
    
    private func loadAttributes() {
        if let _url = url {
            do {
                let attributes = try NSFileManager.defaultManager().attributesOfItemAtPath(_url.path!)
                date = attributes[NSFileCreationDate] as? NSDate
                
            } catch {
                print("error getting file attributes for \(url)")
            }
            
            let audioAsset = WKAudioFileAsset(URL: _url)
            duration = audioAsset.duration
            
            print(self.description)
        }
    }
    
    var description: String {
        get {
            return "AudioClipData \(url) \(date) \(duration)"
        }
    }
    
    var debugDescription: String {
        get {
            return description
        }
    }
}
