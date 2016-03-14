//
//  ViewController.swift
//  WeatherDemo
//
//  Created by ying on 16/3/14.
//  Copyright © 2016年 ying. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    //MARK: - Property
    let locationManager = CLLocationManager()

    //
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        locationManager.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        if (ios9()) {
           locationManager.requestAlwaysAuthorization()
        }
        locationManager.startUpdatingLocation()
    }
    
    func ios9() -> Bool
    {
        print(UIDevice.currentDevice().systemVersion)
        return UIDevice.currentDevice().systemVersion == "9.2"
    }

    //MARK: - Location Delegate
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //取出最后一个
        let location = locations[locations.count - 1]
        if (location.horizontalAccuracy > 0) {
            print("维度：", location.coordinate.latitude)
            print(location.coordinate.longitude)
            updateWeatherInfo(location.coordinate.latitude, longitude: location.coordinate.longitude)
            locationManager.stopUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error)
    }


    //
    func updateWeatherInfo(latitude: CLLocationDegrees, longitude: CLLocationDegrees)
    {
        let manager = AFHTTPSessionManager()
        let url = "http://api.openweathermap.org/data/2.5/weather"
        let appid = "b1b15e88fa797225412429c1c50c122a"
        let params = ["lat": latitude, "lon": longitude, "appid": appid]
        /*
        manager.GET(url, parameters: params, success: { (operation:NSURLSessionDataTask,responseObject:AnyObject?) -> Void in
            print("JSON: ", responseObject!.description)
            })
            { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                print("Error", error.localizedDescription)
        }
        */
        manager.GET(url, parameters: params, progress: nil, success: { (operation: NSURLSessionDataTask, responseObject:AnyObject?) -> Void in
            print("JSON: ", responseObject!.description)
            }) { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                print("Error", error.localizedDescription)
        }
        
        
        
    }
}

