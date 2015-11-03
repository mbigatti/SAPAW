//
//  RowController.swift
//  UICatalog
//
//  Created by Massimiliano Bigatti on 23/06/15.
//  Copyright © 2015 Massimiliano Bigatti. All rights reserved.
//

import WatchKit

class RowController : NSObject {

    @IBOutlet var label: WKInterfaceLabel!
    
    func setText(text: String) {
        label.setText(text)
    }
    
}