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
    
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    //
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var loadingLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        locationManager.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        //start loading animation
        loadingIndicator.startAnimating()
        
        //Add backgroud image to view
        let backgroundImage = UIImage(named: "background.png")
        self.view.backgroundColor = UIColor(patternImage: backgroundImage!)
        
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
            print(location.coordinate.latitude)
            print(location.coordinate.longitude)
            updateWeatherInfo(location.coordinate.latitude, longitude: location.coordinate.longitude)
            locationManager.stopUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error)
        loadingLabel.text = "Geographic Infor Error!"
    }


    //
    func updateWeatherInfo(latitude: CLLocationDegrees, longitude: CLLocationDegrees)
    {
        let manager = AFHTTPSessionManager()
        let url = "http://api.openweathermap.org/data/2.5/weather"
        let appid = "b1b15e88fa797225412429c1c50c122a"
        let params = ["lat": latitude, "lon": longitude, "appid": appid]

        manager.GET(url, parameters: params, progress: nil, success: { (operation: NSURLSessionDataTask, responseObject:AnyObject?) -> Void in
            print("JSON: ", responseObject!.description)
            self.updateWeatherData(responseObject as! NSDictionary)
            
            }) { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                print("Error", error.localizedDescription)
        }
        
        
        
    }
    
    func updateWeatherData(jsonResult: NSDictionary!)
    {
        //stop loading indicator
        loadingIndicator.stopAnimating()
        loadingIndicator.hidden = true
        //hide loading label
        loadingLabel.text = nil
        
        if let temp = jsonResult["main"]!["temp"] as? Double
        {
            var temperature: Double
            if (jsonResult["sys"]!["country"] as! String == "US")
            {
                temperature = round(((temp - 273.15) * 1.8) + 32)
            }
            else
            {
                temperature = round(temp - 273.15)
            }
            
            temperatureLabel.text = "\(temperature) ℃"
            
            let name = jsonResult["name"] as! String
            location.text = "\(name)"
            
            var condition = (jsonResult["weather"] as! NSArray)[0]["id"] as! Int
            var sunrise = jsonResult["sys"]!["sunrise"] as! Double
            var sunset = jsonResult["sys"]!["sunset"] as! Double
            
            var nightTime = false
            var now = NSDate().timeIntervalSince1970
            
            if (now < sunrise || now > sunset)
            {
                nightTime = true
            }
            updateWeatherIcon(condition, nightTime: nightTime)
            
        }
        else
        {
            loadingLabel.text = "Weather Infor Error!"
        }
    }
    
    func updateWeatherIcon(condition: Int, nightTime: Bool)
    {
        if (condition < 300)
        {
            if nightTime
            {
                weatherImageView.image = UIImage(named: "tstorm1_night")
            }
            else
            {
                weatherImageView.image = UIImage(named: "tstorm1")
            }
        }
        else if (condition < 500)
        {
             weatherImageView.image = UIImage(named: "light_rain")
        }
        else if (condition < 600)
        {
             weatherImageView.image = UIImage(named: "shower3")
        }
        else if (condition < 700)
        {
             weatherImageView.image = UIImage(named: "snow4")
        }
        else if (condition < 771)
        {
            if nightTime
            {
                weatherImageView.image = UIImage(named: "fog_night")
            }
            else
            {
                 weatherImageView.image = UIImage(named: "fog")
            }
        }
        else if (condition < 800)
        {
             weatherImageView.image = UIImage(named: "tstorm3")
        }
        else if (condition == 800)
        {
            if nightTime
            {
                weatherImageView.image = UIImage(named: "sunny_night")
            }
            else
            {
                 weatherImageView.image = UIImage(named: "sunny")
            }
        }
        else if (condition < 804)
        {
            if nightTime
            {
                 weatherImageView.image = UIImage(named: "cloudy2_night")
            }
            else
            {
                 weatherImageView.image = UIImage(named: "cloudy2")
            }
        }
        else if (condition == 804)
        {
             weatherImageView.image = UIImage(named: "overcast")
        }
        else if ((condition >= 900 && condition < 903) || (condition > 904 && condition < 1000))
        {
             weatherImageView.image = UIImage(named: "tstorm3")
        }
        else if (condition == 903)
        {
             weatherImageView.image = UIImage(named: "snow5")
        }
        else if (condition == 904)
        {
             weatherImageView.image = UIImage(named: "sunny")
        }
        else
        {
             weatherImageView.image = UIImage(named: "dunno")
        }
    }
}

