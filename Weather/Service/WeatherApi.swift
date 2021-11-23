//
//  WeatherService.swift
//  Weather
//
//  Created by Ingy Salah on 11/20/21.
//

import Foundation
import UIKit

protocol WeatherApiProtocol: AnyObject {
    func weather(weather: CityWeather)
    func weatherFailed(error: BaseError)
}

class WeatherApi {
    
    weak var delegate: WeatherApiProtocol!
    var weatherDataTask: URLSessionDataTask!

    init(delegate: WeatherApiProtocol) {
        self.delegate = delegate
    }
    
    func getWeather(cityName: String) {
        let city = cityName.replacingOccurrences(of: " ", with: "+")
        let url = "\(Configuration.weatherDomain)?key=63878e2d01ad44c7a0c224636211911&q=\(city)&num_of_days=10&format=json&tp=1"
        var req = URLRequest(url: URL(string: url)!)
        req.httpMethod = "GET"
        weatherDataTask = Http.shared.makeNewRequest(req: req, completion: { [self] data in
    
            guard let data = data, let cityWeatherData = CityWeatherApiData.fromData(data: data) else {
                self.delegate?.weatherFailed(error: BaseError(errorCode: .ParsingError))
                return
            }
      
            self.delegate?.weather(weather: cityWeatherData.data)
            
            
        }, failure: { error in
            self.delegate?.weatherFailed(error: error)
        })
        weatherDataTask.resume()
    }
    
}
