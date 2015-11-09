//
//  PedometerHistoryInterfaceController.swift
//  CoreMotionCatalog
//
//  Created by Massimiliano Bigatti on 20/10/15.
//  Copyright © 2015 Massimiliano Bigatti. All rights reserved.
//

import Foundation
import WatchKit
import CoreMotion

class PedometerHistoryInterfaceController : WKInterfaceController {
    @IBOutlet var startDateLabel: WKInterfaceLabel!
    @IBOutlet var endDateLabel: WKInterfaceLabel!    
    @IBOutlet var stepsLabel: WKInterfaceLabel!
    @IBOutlet var distanceLabel: WKInterfaceLabel!
    @IBOutlet var errorLabel: WKInterfaceLabel!
    
    let dateFormatter = NSDateFormatter()
    let numberFormatter = NSNumberFormatter()
    
    let pedometer = CMPedometer()
    let KM_PER_M : Double = 1000
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
                
        pedometer.queryPedometerDataFromDate(NSDate.yesterday(), toDate: NSDate()) { (data: CMPedometerData?, error: NSError?) -> Void in
            if let _error = error {
                self.errorLabel.setText(_error.localizedDescription)
            }
            
            if let _data = data {
                self.dateFormatter.dateFormat = "dd/MM hh:mm:ss"
                
                // @see: http://www.unicode.org/reports/tr35/tr35-31/tr35-numbers.html#Number_Format_Patterns
                self.numberFormatter.positiveFormat = "#,###,###.##"
                
                self.startDateLabel.setText(self.dateFormatter.stringFromDate(_data.startDate))
                self.endDateLabel.setText(self.dateFormatter.stringFromDate(_data.endDate))
                self.stepsLabel.setText(self.numberFormatter.stringFromNumber(_data.numberOfSteps))
                
                if let distance = _data.distance {
                    let km = distance.doubleValue / self.KM_PER_M
                    self.distanceLabel.setText(self.numberFormatter.stringFromNumber(NSNumber(double: km)))
                }
            }
        }
    }
}