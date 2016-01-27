//
//  WeatherDataFetcher.swift
//  WeatherApp
//
//  Created by Massimiliano Bigatti on 15/07/15.
//  Copyright © 2015 Massimiliano Bigatti. All rights reserved.
//

import Foundation
import CoreLocation
import WatchConnectivity


class WeatherDataFetcher : NSObject, CLLocationManagerDelegate, WCSessionDelegate {
    static let sharedInstance = WeatherDataFetcher()
    
    let wundergroundAPIToken = "INDICARE QUI LE PROPRIE API DI ACCESSO AL SERVIZIO"
    
    let locationManager = CLLocationManager()
    
    var currentLocation = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var currentLocationDescription: String?
    var lastUpdateDate : NSDate?
    var hourlyForecast : [String: AnyObject]?
    
    let session = WCSession.defaultSession()
    
    lazy var dateFormatter: NSDateFormatter = {
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter;
        
    }()
    
    override init() {
        super.init()
        
        //
        // location stuff
        //
        locationManager.delegate = self
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        //
        // watch connectivity
        //
        session.delegate = self
        session.activateSession()        
    }

    func fetchWeather() {
        print("fetchWeather()")
        
        switch CLLocationManager.authorizationStatus() {
        case .NotDetermined:
            locationManager.requestAlwaysAuthorization()
            
        case .AuthorizedAlways:
            locationManager.startUpdatingLocation()
            
        default:
            break
        }
    }
    
    
    //
    // MARK: CLLocationManager
    //
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        
        let location = locations.last
        
        guard location?.coordinate != nil else {
            return
        }
        
        if let _location = location {
            if !coordinateEquals(currentLocation, _location.coordinate) {
                currentLocation = _location.coordinate
                updateLocation(_location.coordinate.latitude, _location.coordinate.longitude)
            }
        }
    }
    
    func coordinateEquals(coordinate1: CLLocationCoordinate2D, _ coordinate2: CLLocationCoordinate2D) -> Bool {
        let CLCOORDINATE_EPSILON = 0.005
        
        return (fabs(coordinate1.latitude - coordinate2.latitude) < CLCOORDINATE_EPSILON && fabs(coordinate1.longitude - coordinate2.longitude) < CLCOORDINATE_EPSILON)
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.AuthorizedAlways {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("CLLocationManager didFailWithError: \(error)")
    }

    
    //
    // MARK: Privates
    //
    
    func updateLocation(latitude: CLLocationDegrees, _ longitude: CLLocationDegrees) {
        let url = "http://api.wunderground.com/api/\(wundergroundAPIToken)/geolookup/q/\(latitude),\(longitude).json"
        print("geolookup: \(url)")
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: url)!) { (data, urlResponse, error) -> Void in
            if (error != nil) {
                print("Error fetching feed \(error)")
                
            } else {
                print("location data downloaded")
                
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as! NSDictionary
                    let location = json.objectForKey("location") as! NSDictionary
                    let city = location.objectForKey("city") as! String
                    let country = location.objectForKey("country") as! String
                    
                    self.currentLocationDescription = "\(city) (\(country))"
                    print("current location \(self.currentLocationDescription)")
                    
                    let userInfo = [kLocationUserInfoKey: self.currentLocationDescription!]
                    NSNotificationCenter.defaultCenter().postNotificationName(kDidReceiveLocationDescriptionFromService, object: self, userInfo: userInfo)
                    
                    self.updateWeather(latitude, longitude)
                    
                } catch {
                    print("error deserializing JSON data")
                }
            }
        }
        
        task.resume()
    }
    
    func updateWeather(latitude: CLLocationDegrees, _ longitude: CLLocationDegrees) {
        let url = "http://api.wunderground.com/api/\(wundergroundAPIToken)/hourly/q/\(latitude),\(longitude).json"
        print("weather: \(url)")
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: url)!) { (data, urlResponse, error) -> Void in
            if (error != nil) {
                print("Error fetching feed \(error)")
                
            } else {
                print("weather data downloaded")
                
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as! NSDictionary
                    let hourly = json.objectForKey("hourly_forecast") as! NSArray
                    
                    var dates = [NSDate]()
                    var temps = [String]()
                    var conditions = [String]()
                    var icons = [String]()
                    
                    for hour in hourly {
                        let condition = hour.objectForKey("condition") as! String
                        let icon = hour.objectForKey("icon") as! String
                        
                        let hourDictionary = hour as! NSDictionary
                        let fctime = hourDictionary["FCTTIME"] as! NSDictionary
                        
                        if let date = self.parseFCTime(fctime) {
                            let temp = hourDictionary.objectForKey("temp") as! NSDictionary
                            let tempCelsius = temp.objectForKey("metric") as! String
                            
                            dates.append(date)
                            temps.append(tempCelsius)
                            conditions.append(condition)
                            icons.append(icon)
                        }
                    }
                    
                    var context = [String: AnyObject]()
                    context["dates"] = dates
                    context["temps"] = temps
                    context["conditions"] = conditions
                    context["icons"] = icons
                    context["location"] = self.currentLocationDescription
                    
                    self.hourlyForecast = context
                    self.lastUpdateDate = NSDate()
                    
                    let weatherForecast = WeatherForecast(location: self.currentLocationDescription!, dates: dates, temperatures: temps, conditions: conditions, icons: icons)
                    let userInfo = [kForecastUserInfoKey: weatherForecast]
                    NSNotificationCenter.defaultCenter().postNotificationName(kDidReceiveWheaterDataFromService, object: self, userInfo: userInfo)
                    
                    self.watchSync()
                    
                } catch {
                    print("error deserializing JSON data")
                }
            }
        }
        
        task.resume()
    }
    
    
    func parseFCTime(fctime: NSDictionary) -> NSDate? {
        let hour = fctime["hour_padded"] as! String
        let min = fctime["min"] as! String
        let sec = fctime["sec"] as! String
        let mday = fctime["mday"] as! String
        let mon = fctime["mon"] as! String
        let year = fctime["year"] as! String
        
        let dateString = "\(year)-\(mon)-\(mday) \(hour):\(min):\(sec)"
        
        return dateFormatter.dateFromString(dateString)
    }
    
    
    //
    // MARK: Watch Connectivity
    //
    
    func watchSync() {
        print("watchSync() supported=\(WCSession.isSupported()), paired=\(session.paired), watchAppInstalled=\(session.watchAppInstalled)")
        
        if WCSession.isSupported() && session.paired && session.watchAppInstalled {
            do {
                try WCSession.defaultSession().updateApplicationContext(self.hourlyForecast!)
                
            } catch {
                print("Watch Connectivity not available  \(error)")
            }
            
            // WCSession.defaultSession().transferCurrentComplicationUserInfo(self.hourlyForecast!)
        }
    }
    
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject]) {
        print("received weather data request from the watch")

        if lastUpdateDate == nil {
            fetchWeather()
            
        } else {
            let kThreeHours : NSTimeInterval = 3 * 60 * 60
            let limitDate = lastUpdateDate!.dateByAddingTimeInterval(kThreeHours)
            let now = NSDate()
            
            if now.compare(limitDate) == NSComparisonResult.OrderedDescending {
                fetchWeather()
                
            } else {
                watchSync()
            }
        }
    }
}
