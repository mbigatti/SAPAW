//
//  MenuInterfaceController.swift
//  UICatalog
//
//  Created by Massimiliano Bigatti on 20/07/15.
//  Copyright © 2015 Massimiliano Bigatti. All rights reserved.
//

import Foundation
import WatchKit

class MenuInterfaceController : WKInterfaceController {
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        self.addMenuItemWithImageNamed("present-menu-item", title: "Gift 2", action: "giftMenuSelected")
    }
    
    func giftMenuSelected() {
        print("giftMenuSelected")
    }
    
}
