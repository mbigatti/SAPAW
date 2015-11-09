//
//  NotificationController.swift
//  WatchApp Extension
//
//  Created by Massimiliano Bigatti on 18/06/15.
//  Copyright © 2015 Massimiliano Bigatti. All rights reserved.
//

import WatchKit
import Foundation


class NotificationController: WKUserNotificationInterfaceController {

    @IBOutlet var durationLabel: WKInterfaceLabel!
    @IBOutlet var startLabel: WKInterfaceLabel!
    @IBOutlet var endLabel: WKInterfaceLabel!
    
    let dateFormatter = NSDateFormatter()
    
    override init() {
        dateFormatter.dateFormat = "HH:mm"
        super.init()
    }
    
    override func didReceiveLocalNotification(localNotification: UILocalNotification, withCompletion completionHandler: ((WKUserNotificationInterfaceType) -> Void)) {
        
        if let duration = localNotification.userInfo?[kDurationNotificationKey] as? NSTimeInterval {
            durationLabel.setText(String(format: "%2.0f", arguments: [duration]))
            
            if let startDate = localNotification.userInfo?[kStartNotificationKey] as? NSDate {
                startLabel.setText(dateFormatter.stringFromDate(startDate))

                if let endDate = localNotification.userInfo?[kEndNotificationKey] as? NSDate {
                    endLabel.setText(dateFormatter.stringFromDate(endDate))
                    
                    completionHandler(.Custom)
                    return
                }
            }
        }
        
        completionHandler(.Default)
    }

}
