//
//  InputViewController.swift
//  UICatalog
//
//  Created by Massimiliano Bigatti on 09/07/15.
//  Copyright © 2015 Massimiliano Bigatti. All rights reserved.
//

import WatchKit
import Foundation


class InputViewController : WKInterfaceController {
    
    @IBOutlet var label: WKInterfaceLabel!
    @IBOutlet var image: WKInterfaceImage!
    @IBOutlet var button: WKInterfaceButton!
    
    let suggestions = [ "OK", "Arrivo!", "Ti chiamo dopo", "Così così", "Buon Week End"]
    
    override func willActivate() {
        super.willActivate()
        
        moreButtonTapped()
    }
    
    @IBAction func moreButtonTapped() {
        self.label.setHidden(true)
        self.image.setHidden(true)
        self.button.setHidden(true)
        
        self.presentTextInputControllerWithSuggestions(suggestions, allowedInputMode: .AllowAnimatedEmoji) { (selections: [AnyObject]?) -> Void in
            
            guard selections?.count != 0 else {
                return
            }
            
            let selection = selections?.last
            
            if selection is String {
                self.label.setHidden(false)
                self.label.setText("Hai selezionato: \(selection!)")
            }
            
            if selection is NSData {
                self.image.setHidden(false)
                self.image.setImageData(selection as? NSData)
            }
            
            self.button.setHidden(false)
        }
    }
    
}
