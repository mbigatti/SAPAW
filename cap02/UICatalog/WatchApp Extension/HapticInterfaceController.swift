//
//  HapticInterfaceController.swift
//  UICatalog
//
//  Created by Massimiliano Bigatti on 29/06/15.
//  Copyright © 2015 Massimiliano Bigatti. All rights reserved.
//

import WatchKit

class HapticInterfaceControlle : WKInterfaceController {
    
    @IBOutlet var picker: WKInterfacePicker!
    
    let descriptions = [
        "Notification",
        "DirectionUp",
        "DirectionDown",
        "Success",
        "Failure",
        "Retry",
        "Start",
        "Stop",
        "Click"
    ]
    
    let types : [WKHapticType] = [
        .Notification,
        .DirectionUp,
        .DirectionDown,
        .Success,
        .Failure,
        .Retry,
        .Start,
        .Stop,
        .Click
    ]
    
    var selectedHapticType: WKHapticType?
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        var items = [WKPickerItem]()
        for description in descriptions {
            let item = WKPickerItem()
            item.title = description
            items.append(item)
        }
        picker.setItems(items)
    }
    
    @IBAction func pickerAction(value: Int) {
        selectedHapticType = types[value]
    }
    
    @IBAction func playHapticButtonTapped() {
        guard selectedHapticType != nil else {
            return
        }
        WKInterfaceDevice.currentDevice().playHaptic(selectedHapticType!)
    }

}
