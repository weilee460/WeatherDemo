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
    
    let locationManager = CLLocationManager()

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

    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //取出最后一个
        let location = locations[locations.count - 1]
        if (location.horizontalAccuracy > 0) {
            print("维度：", location.coordinate.latitude)
            print(location.coordinate.longitude)
            
            locationManager.stopUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error)
    }


}

