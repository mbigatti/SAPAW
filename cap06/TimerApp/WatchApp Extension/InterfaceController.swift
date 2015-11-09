//
//  InterfaceController.swift
//  WatchApp Extension
//
//  Created by Massimiliano Bigatti on 18/06/15.
//  Copyright © 2015 Massimiliano Bigatti. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity


class InterfaceController: WKInterfaceController, WCSessionDelegate {

    @IBOutlet var group: WKInterfaceGroup!
    @IBOutlet var picker: WKInterfacePicker!
    @IBOutlet var timerLabel: WKInterfaceTimer!
    @IBOutlet var startOrStopButton: WKInterfaceButton!
    
    let kDefaultMinutes = 3
    let kSecondsPerMinute = 1 // 60
    
    let session = WCSession.defaultSession()
    
    var running = false
    
    var minutes = 0
    var interval : NSTimeInterval?
    var fireDate : NSDate?
    
    //
    // MARK: - Lifecycle
    //
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        
        // enable Watch Connectivity
        session.delegate = self
        session.activateSession()

        
        //
        // init picker
        //
        var images: [UIImage]! = []
        var pickerItems: [WKPickerItem]! = []
        
        for index in 1...60 {
            let name = "progress-\(index)"
            images.append(UIImage(named: name)!)
            
            let pickerItem = WKPickerItem()
            pickerItems.append(pickerItem)
        }
    
        let progressImages = UIImage.animatedImageWithImages(images, duration: 0.0)
        group.setBackgroundImage(progressImages)
        
        picker.setCoordinatedAnimations([group])
        picker.setItems(pickerItems)
        picker.focus()
        
        picker.setSelectedItemIndex(kDefaultMinutes - 1)
        pickerAction(kDefaultMinutes - 1)
        
        updateFireDate()
        updateUI()
    }
    
    override func willActivate() {
        super.willActivate()
        
        if fireDate?.compare(NSDate()) == NSComparisonResult.OrderedAscending {
            resetTimer()
        }
    }

    
    //
    // MARK: - Actions
    //
    
    @IBAction func startOrStop() {
        print("button pressed, running=\(running)")
        
        running = !running
        
        updateFireDate()
        updateUI()
        
        if running {
            timerLabel.start()
            scheduleLocalNotification(fireDate!, duration: interval!)
            
        } else {
            timerLabel.stop()
            cancelLocalNotification()
        }
    }
    
    @IBAction func pickerAction(value: Int) {
        minutes = value + 1
        
        updateFireDate()
        updateUI()
        
        print("selected \(minutes) minutes")
    }

    
    //
    // MARK: - Privates
    //
    
    func updateFireDate() {
        interval = NSTimeInterval(minutes * kSecondsPerMinute)
        fireDate = NSDate(timeIntervalSinceNow: interval! + 1)
    }
    
    func updateUI() {
        timerLabel.setDate(fireDate!)
        startOrStopButton.setTitle(running ? "Stop" : "Start")
    }
    
    func resetTimer() {
        running = false
        updateFireDate()
        updateUI()
    }
    
    func timerEnded() {
        timerLabel.stop()
        resetTimer()
        
        let defaultAction = WKAlertAction(title: "OK", style: .Default) {}
        self.presentAlertControllerWithTitle("TimerApp", message: "Tempo scaduto", preferredStyle: WKAlertControllerStyle.Alert, actions: [defaultAction])
        
    }

    
    //
    // MARK: - Schedule and Cancel notifications
    //
    
    func scheduleLocalNotification(fireDate: NSDate, duration: NSTimeInterval) {
        guard WCSession.isSupported() && session.reachable else {
            print("unable to schedule notification")
            return
        }
        
        session.sendMessage([ kScheduleNotificationMessageKey: fireDate, kDurationMessageKey: duration ], replyHandler: nil) { (error: NSError) -> Void in
            print("scheduleLocalNotification: \(error)")
        }
        
        print("local notification scheduled")
    }
    
    func cancelLocalNotification() {
        guard WCSession.isSupported() && session.reachable else {
            print("unable to cancel notification")
            return
        }
        
        session.sendMessage([ kCancelNotificationMessageKey: true ], replyHandler: nil) { (error: NSError) -> Void in
            print("cancelLocalNotification: \(error)")
        }
        
        print("local notification cancelled")
    }

}
