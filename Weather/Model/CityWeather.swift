//
//  CityWeather.swift
//  Weather
//
//  Created by Ingy Salah on 11/21/21.
//

import Foundation

class CityWeather: Codable {
    
    var current_condition: [CurrentWeather]!
    var weather: [DayWeather]!
    
    func getCurrentWeather() -> CurrentWeather {
        return current_condition[0]
    }
    
}

class CityWeatherApiData: Codable {
    var data: CityWeather!
}
