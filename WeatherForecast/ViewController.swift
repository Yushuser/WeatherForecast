//
//  ViewController.swift
//  WeatherForecast
//
//  Created by YUSHU WU on 11/19/22.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON
import SwiftSpinner

class ViewController: UIViewController, CLLocationManagerDelegate , UITableViewDelegate, UITableViewDataSource{
    
    
    @IBOutlet weak var txtCity: UITextField!
    
    @IBOutlet weak var tblView: UITableView!
    
    let locationManager = CLLocationManager()
    var lat: CLLocationDegrees?
    var lng: CLLocationDegrees?
    var arr: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let location = locations.last else { return }
            lat = location.coordinate.latitude
            lng = location.coordinate.longitude
            print(lat)
            print(lng)
//            getAddressFromLocation(location: location)
    }
    
    @IBAction func getLocation(_ sender: Any) {
        let locationStr = "\(self.lat!),\(self.lng!)"
        
        var url = "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/weatherdata/forecast?locations="
        url += locationStr
        url += "&aggregateHours=24&unitGroup=us&shortColumnNames=false&contentType=json&key=YOURAPIKEY"
        
        AF.request(url).responseJSON { responseData in
            //print(responseData)
            if responseData.error != nil {
                print(responseData.error!)
                return
            }
            
            let weatherData = JSON(responseData.data as Any)
            let forecastValues =  weatherData["locations"][locationStr]["values"]
            
            print(forecastValues.count)
            
            self.arr = [String]()
            for forecast in forecastValues {
                let forecastJSON = JSON(forecast.1)
                let temp = forecastJSON["temp"].floatValue
                let conditions = forecastJSON["conditions"].stringValue
//                let dateTime = forecastJSON["datetimeStr"].stringValue.prefix(10)
                self.arr.append("Temp = \(temp)℉, \(conditions) ")
                print(forecast)
            }
            self.tblView.reloadData()
        }
    }
    
    @IBAction func getWeather(_ sender: Any) {
    let cityName = txtCity.text!
        
        var url = "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/weatherdata/forecast?locations="
        url += cityName + "&aggregateHours=24&unitGroup=us&shortColumnNames=false&contentType=json&key=YOURAPIKEY"
        
        AF.request(url).responseJSON { responseData in
            //print(responseData)
            if responseData.error != nil {
                print(responseData.error!)
                return
            }
            
            let weatherData = JSON(responseData.data as Any)
            let forecastValues =  weatherData["locations"][cityName]["values"]
            
            print(forecastValues.count)
            
            self.arr = [String]()
            for forecast in forecastValues {
                let forecastJSON = JSON(forecast.1)
                let temp = forecastJSON["temp"].floatValue
                let conditions = forecastJSON["conditions"].stringValue
                self.arr.append("Temp = \(temp)℉, \(conditions) ")
                print(forecast)
            }
            self.tblView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = arr[indexPath.row]
        return cell
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    

}
