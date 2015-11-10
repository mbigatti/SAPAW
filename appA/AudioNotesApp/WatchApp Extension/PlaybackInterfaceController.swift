//
//  PlaybackInterfaceController.swift
//  AudioNotesApp
//
//  Created by Massimiliano Bigatti on 18/10/15.
//  Copyright © 2015 Massimiliano Bigatti. All rights reserved.
//

import WatchKit
import Foundation

class PlaybackInterfaceController: WKInterfaceController {
    @IBOutlet var titleLabel: WKInterfaceLabel!
    @IBOutlet var durationLabel: WKInterfaceLabel!
    @IBOutlet var statusLabel: WKInterfaceLabel!

    let kUIRefreshRate = 0.25
    
    var queuePlayer : WKAudioFileQueuePlayer?
    
    
    //
    // MARK: - WKInterfaceController
    //
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        if let playerItemArray = context as? [WKAudioFilePlayerItem] {
            queuePlayer = WKAudioFileQueuePlayer(items: playerItemArray)
            
            let _ = NSTimer.scheduledTimerWithTimeInterval(kUIRefreshRate, target: self, selector: "checkQueuePlayerStatus:", userInfo: nil, repeats: true)
            
            updateUIWithPlayerItem(playerItemArray.first)
            statusLabel.setText("Inizio riproduzione \(playerItemArray.count) elementi")
        }
    }
    
    override func willActivate() {
        super.willActivate()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "playerDidPlayToEnd", name: WKAudioFilePlayerItemDidPlayToEndTimeNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "playerFailedToPlayToEnd", name: WKAudioFilePlayerItemFailedToPlayToEndTimeNotification, object: nil)
    }
    
    override func didDeactivate() {
        super.didDeactivate()
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    //
    // MARK: - Actions
    //
    
    @IBAction func stop() {
        queuePlayer?.pause()
        dismissController()
    }
    
    
    //
    // MARK: - Timers
    //
    
    func checkQueuePlayerStatus(timer : NSTimer) {
        if updateStatusForPlayer(queuePlayer) {
            updateUIWithPlayerItem(queuePlayer?.currentItem)
            
            timer.invalidate()
        }
    }
    
    
    //
    // MARK: - Notifications
    //
    
    func playerDidPlayToEnd() {
        if queuePlayer?.currentItem == nil {
            statusLabel.setText("Riproduzione terminata")
        } else {
            updateUIWithPlayerItem(queuePlayer?.currentItem)
        }
    }
    
    func playerFailedToPlayToEnd() {
        statusLabel.setText("Riproduzione fallita")
    }
    
    
    //
    // MARK: - Privates
    //
    
    private func updateUIWithPlayerItem(item: WKAudioFilePlayerItem?) {
        if let _item = item {
            statusLabel.setText("In riproduzione")
            
            if let title = _item.asset.title {
                titleLabel.setText(title)
            }
            
            durationLabel.setText("\(_item.asset.duration)")
            
        } else {
            statusLabel.setText("Pronto")
        }
    }
    
    private func updateStatusForPlayer(player: WKAudioFilePlayer?) -> Bool {
        if let status = player?.status {
            switch status {
            case .ReadyToPlay:
                statusLabel.setText("Riproduco...")
                player?.play()
                
                return true
                
            case .Failed:
                statusLabel.setText("Fallito \(player?.error?.localizedDescription)")
                
            case .Unknown:
                statusLabel.setText("Preparazione...")
            }
        }
        
        return false
    }
    
}
