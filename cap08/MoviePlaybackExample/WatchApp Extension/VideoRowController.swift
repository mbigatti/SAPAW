//
//  VideoRowController.swift
//  MultimediaCatalog
//
//  Created by Massimiliano Bigatti on 10/07/15.
//  Copyright © 2015 Massimiliano Bigatti. All rights reserved.
//

import WatchKit

class VideoRowController : NSObject {
    
    @IBOutlet weak var image: WKInterfaceImage!
    @IBOutlet weak var label: WKInterfaceLabel!

    func setDescription(description: String) {
        label.setText(description)
    }
    
    func setImageName(imageName: String) {
        image.setImageNamed(imageName)
    }
}

