//
//  DictationInterfaceController.swift
//  UICatalog
//
//  Created by Massimiliano Bigatti on 09/07/15.
//  Copyright © 2015 Massimiliano Bigatti. All rights reserved.
//

import WatchKit
import Foundation


class DictationInterfaceController : WKInterfaceController {
    
    override func willActivate() {
        super.willActivate()
        
        self.presentTextInputControllerWithSuggestions(nil, allowedInputMode: .Plain) { (selections: [AnyObject]?) -> Void in
            
            guard selections?.count != 0 else {
                return
            }
            
            if let strings = selections as! [String]? {
                let text = strings.reduce("") { $0 + $1 }
                print("\(text)")
            }
        }        
    }
    
}
