//
//  AlertInterfaceController.swift
//  UICatalog
//
//  Created by Massimiliano Bigatti on 24/06/15.
//  Copyright © 2015 Massimiliano Bigatti. All rights reserved.
//

import WatchKit

class AlertInterfaceController : WKInterfaceController {
    
    @IBAction func alertButtonTapped() {
        presentAlert(.Alert)
    }
    
    @IBAction func sideBySideButtonTapped() {
        presentAlert(.SideBySideButtonsAlert)
    }
    
    @IBAction func actionSheetButtonTapped() {
        presentAlert(.ActionSheet)
    }

    func presentAlert(style: WKAlertControllerStyle!) {
        let defaultAction = WKAlertAction(title: "OK", style: .Default) {}
        let cancelAction = WKAlertAction(title: "Annulla", style: .Cancel) {}
        let destructiveAction = WKAlertAction(title: "Distruttivo", style: .Destructive) {}
        
        var actions = [defaultAction, cancelAction]
        
        if style != WKAlertControllerStyle.SideBySideButtonsAlert {
            actions.append(destructiveAction)
        }
        
        self.presentAlertControllerWithTitle("UICatalog", message: "Messaggio di avviso", preferredStyle: style, actions: actions)        
    }
    
}

