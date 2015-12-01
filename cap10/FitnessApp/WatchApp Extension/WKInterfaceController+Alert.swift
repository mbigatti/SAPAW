//
//  WKInterfaceController+Alert.swift
//  PodcastApp
//
//  Created by Massimiliano Bigatti on 14/07/15.
//  Copyright © 2015 Massimiliano Bigatti. All rights reserved.
//

import WatchKit
import Foundation

extension WKInterfaceController {
    func presentAlertWithMessage(message: String) {
        let defaultAction = WKAlertAction(title: "OK", style: .Default) {}
        self.presentAlertControllerWithTitle("Fitness App", message: message, preferredStyle: WKAlertControllerStyle.Alert, actions: [defaultAction])
    }
}
