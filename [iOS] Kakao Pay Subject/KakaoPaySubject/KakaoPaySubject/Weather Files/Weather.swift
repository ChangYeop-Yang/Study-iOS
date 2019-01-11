//
//  Weather.swift
//  LazyHUE
//
//  Created by 양창엽 on 2018. 8. 11..
//  Copyright © 2018년 양창엽. All rights reserved.
//

import Alamofire

public class Weather: NSObject {
    
    // MARK: - Struct
    public struct WeatherINF {
        // Struct Element -> Double
        var temperature: Double = 0.0
        var humidity:    Double = 0.0
        var visibility:  Double = 0.0
        var ozone:       Double = 0.0
        
        // Struct Element -> String
        var sky:         String = "정보없음"
        var icon:        String = "partly-cloudy-night"
    }
    
    // MARK: - Variables
    public static let weatherInstance: Weather = Weather()
    private var       weatherData: WeatherINF  = WeatherINF()
    
    // MARK: - Init
    private override init() {}
    
    // MARK: - Method
    public func getWeatherInformation() -> WeatherINF { return self.weatherData }
    public func receiveWeatherData(group: DispatchGroup, language: String, latitude: Double, longtitude: Double) {
        
        let weatherURL: String = "https://api.darksky.net/forecast/\(WEATHER_OPEN_API_KEY)/\(latitude),\(longtitude)?units=si&lang=\(language)"
        
        group.enter()
        DispatchQueue.global(qos: .userInteractive).async(group: group, execute: { [unowned self] in
            
            Alamofire.request(weatherURL).responseJSON(completionHandler: { (response) in
                
                guard response.result.isSuccess else {
                    group.leave()
                    fatalError("❌ Error, Not Receive Data From Dark SKY Server.")
                }
                
                switch response.response?.statusCode {
                    case .none : print("❌ Error, Not Receive Data From Dark SKY Server.")
                    case .some(_) :
                        guard let result = response.result.value, let json = result as? NSDictionary else { return }
                        guard let list   = json["currently"] as? [String:Any] else { return }
                        
                        self.weatherData.temperature    = list["apparentTemperature"] as! Double
                        self.weatherData.humidity       = list["humidity"] as! Double
                        self.weatherData.visibility     = list["visibility"] as! Double
                        self.weatherData.ozone          = list["ozone"] as! Double
                        self.weatherData.sky            = list["summary"] as! String
                        self.weatherData.icon           = list["icon"] as! String
                }
                group.leave()
            })
        })

    }
}
