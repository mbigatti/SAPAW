//
//  MainInterfaceController.swift
//  WatchApp Extension
//
//  Created by Massimiliano Bigatti on 22/06/15.
//  Copyright © 2015 Massimiliano Bigatti. All rights reserved.
//

import WatchKit
import Foundation


class MainInterfaceController : WKInterfaceController {
    
    @IBOutlet var table: WKInterfaceTable!
    
    let controllers = [
        "Button",
        "Label",
        "Date",
        "Timer",
        "Slider",
        "Switch",
        "Image",
        "ActivityIndicator",
        "Movie",
        "Map",
        "Separator",
        "Group",
        "ListPicker",
        "StackPicker",
        "SequencePicker",
        "CoordinatedImagePicker",
        "Alert",
        "Menu",
        "Input",
        "Dictation",
        "Haptic",
        "Modal"
    ]
    
    override func willActivate() {
        super.willActivate()
        
        table.setNumberOfRows(controllers.count, withRowType: "RowController")
        
        for index in 0..<controllers.count {
            let row = table.rowControllerAtIndex(index) as! RowController
            row.setText(controllers[index])
        }
        
    }
    
    
    // =========================================================================
    // MARK: WKInterfaceTable
    
    override func table(table: WKInterfaceTable, didSelectRowAtIndex rowIndex: Int) {
        let name = controllers[rowIndex]
        if name == "Modal" {
            self.presentControllerWithName(name, context: nil)
        } else {
            self.pushControllerWithName(name, context: nil)
        }
    }

}
