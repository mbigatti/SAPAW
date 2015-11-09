//
//  LocationDetailRowController.swift
//  CoreLocationCatalog
//
//  Created by Massimiliano Bigatti on 09/07/15.
//  Copyright © 2015 Massimiliano Bigatti. All rights reserved.
//

import WatchKit

class LocationDetailRowController : NSObject {
    
    @IBOutlet weak var contentLabel: WKInterfaceLabel!
    @IBOutlet weak var descriptionLabel: WKInterfaceLabel!
    
    func setContent(content: String?) {
        if let _content = content {
            contentLabel.setText(_content)
        } else {
            contentLabel.setText("")
        }
    }
    
    func setDescription(description: String) {
        descriptionLabel.setText(description)
    }
}