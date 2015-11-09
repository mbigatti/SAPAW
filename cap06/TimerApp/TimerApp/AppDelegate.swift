//
//  AppDelegate.swift
//  TimerApp
//
//  Created by Massimiliano Bigatti on 18/06/15.
//  Copyright © 2015 Massimiliano Bigatti. All rights reserved.
//

import UIKit
import WatchConnectivity


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, WCSessionDelegate {

    var window: UIWindow?
    
    let session = WCSession.defaultSession()
    var notification = UILocalNotification()
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        //
        // Register User Notification
        //
        let postponeAction = UIMutableUserNotificationAction()
        postponeAction.title = "Ritarda"
        postponeAction.identifier = "postpone"
        postponeAction.activationMode = .Foreground
        postponeAction.authenticationRequired = false
        
        let timerCategory = UIMutableUserNotificationCategory()
        timerCategory.setActions([postponeAction], forContext: .Default)
        timerCategory.identifier = "style3"
        
        let categories : Set<UIUserNotificationCategory> = [timerCategory]
        
        let settings = UIUserNotificationSettings(forTypes: UIUserNotificationType.Alert, categories: categories)
        
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
        
        
        //
        // enable Watch Connectivity
        //
        session.delegate = self
        session.activateSession()
        
        
        //
        // prepare notification
        //
        notification.alertBody = "Tempo scaduto"
        notification.alertAction = "Dismiss"
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.category = "style0"
        
        return true
    }

    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        print("didRegisterUserNotificationSettings: \(notificationSettings)")
    }


    //
    // MARK: - WCSessionDelegate
    //
    
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject]) {
        print("received message \(message)")
        
        if message[kScheduleNotificationMessageKey] != nil {
            notification.fireDate = message[kScheduleNotificationMessageKey] as? NSDate
            notification.userInfo = [
                kStartNotificationKey : NSDate(),
                kEndNotificationKey: notification.fireDate!,
                kDurationNotificationKey: message[kDurationMessageKey]!
            ]
            UIApplication.sharedApplication().scheduleLocalNotification(notification)
            print("scheduled local notification on date \(notification.fireDate), now \(NSDate())")
        }
        
        if message[kCancelNotificationMessageKey] != nil {
            UIApplication.sharedApplication().cancelLocalNotification(notification)
            print("local notification canceled")
        }
    }
    
}

