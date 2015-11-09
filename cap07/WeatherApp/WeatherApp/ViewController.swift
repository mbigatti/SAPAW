//
//  ViewController.swift
//  WeatherApp
//
//  Created by Massimiliano Bigatti on 18/06/15.
//  Copyright © 2015 Massimiliano Bigatti. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!    
    @IBOutlet weak var imageView: UIImageView!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationLabel.text = ""
        conditionLabel.text = ""
        temperatureLabel.text = ""
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didReceiveLocationDescriptionFromService:", name: kDidReceiveLocationDescriptionFromService, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didReceiveWheaterDataFromService:", name: kDidReceiveWheaterDataFromService, object: nil)
    }
    
    /*
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            locationManager.requestAlwaysAuthorization()
        }
    }
    */

    func didReceiveLocationDescriptionFromService(notification: NSNotification) {
        dispatch_async(dispatch_get_main_queue(), {
            self.locationLabel.text = notification.userInfo?[kLocationUserInfoKey] as? String
        })
    }
    
    func didReceiveWheaterDataFromService(notification: NSNotification) {
        dispatch_async(dispatch_get_main_queue(), {
            if let weatherForecast = notification.userInfo?[kForecastUserInfoKey] as? WeatherForecast {
                weatherForecast.debugDump()
                
                if let weatherForecastData = weatherForecast.weatherForDate(NSDate()) {
                    self.conditionLabel.text = weatherForecastData.condition
                    self.temperatureLabel.text = weatherForecastData.temp
                    self.imageView.image = UIImage(named: weatherForecastData.icon)
                }
             }
        })
    }
    
}
