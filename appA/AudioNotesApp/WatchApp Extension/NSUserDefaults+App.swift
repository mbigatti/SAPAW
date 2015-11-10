//
//  NSUserDefaults+App.swift
//  AudioNotesApp
//
//  Created by Massimiliano Bigatti on 09/11/15.
//  Copyright © 2015 Massimiliano Bigatti. All rights reserved.
//

import Foundation
import WatchKit


extension NSUserDefaults {
    
    func registrationDuration() -> NSTimeInterval {
        return self.doubleForKey("registration_maximum_duration")
    }
    
    func registrationPreset() -> WKAudioRecorderPreset? {
        if let preset = self.stringForKey("audio_preset") {
            switch preset {
                case "narrow": return .NarrowBandSpeech
                case "wide": return .WideBandSpeech
                case "hq": return .HighQualityAudio
                default: break
            }
        }
        return nil
    }
    
    func enableDeletion() -> Bool {
        return self.boolForKey("enable_delete")
    }
}