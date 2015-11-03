//
//  MainInterfaceController.swift
//  WatchApp Extension
//
//  Created by Massimiliano Bigatti on 20/07/15.
//  Copyright © 2015 Massimiliano Bigatti. All rights reserved.
//

import WatchKit
import Foundation


class MainInterfaceController: WKInterfaceController {

    @IBOutlet var table: WKInterfaceTable!
    
    let controllers = [
        "Appare",
        "Scompare",
        "Pulsa",
        "Blocco completamento",
        "Riposizionamento",
        "Visualizzazione in sequenza",
        "Animazione gruppo"
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
        self.pushControllerWithName(name, context: nil)
    }

}
