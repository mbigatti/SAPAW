//
//  InterfaceController.swift
//  WatchApp Extension
//
//  Created by Massimiliano Bigatti on 18/06/15.
//  Copyright © 2015 Massimiliano Bigatti. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController {
    
    @IBOutlet var image: WKInterfaceImage!
    @IBOutlet var locationLabel: WKInterfaceLabel!
    @IBOutlet var conditionLabel: WKInterfaceLabel!    
    @IBOutlet var temperatureLabel: WKInterfaceLabel!
    
    override func willActivate() {
        super.willActivate()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didReceiveWeatherDataFromPhone", name: kDidReceiveWeatherDataFromPhone, object: nil)
        
        locationLabel.setText("")
        temperatureLabel.setText("")
        conditionLabel.setText("")
        
        if weatherForecast != nil {
            didReceiveWeatherDataFromPhone()
        }
    }
    
    override func didDeactivate() {
        super.didDeactivate()        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    @objc func didReceiveWeatherDataFromPhone() {
        if let weatherForecastData = weatherForecast?.weatherForDate(NSDate()) {
            dispatch_async(dispatch_get_main_queue()) {
                self.image.setImageNamed(weatherForecastData.icon)
                self.locationLabel.setText(weatherForecast?.location)
                self.temperatureLabel.setText("\(weatherForecastData.temp)°")
                self.conditionLabel.setText(weatherForecastData.condition)
            }
        }
    }

}
