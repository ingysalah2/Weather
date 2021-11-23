//
//  HourlyWeather.swift
//  Weather
//
//  Created by Ingy Salah on 11/22/21.
//

import Foundation

class HourlyWeather: Codable {
    
    var tempC: String!
    var time: String!
    var weatherIconUrl: [[String:String]]!
    
    
    func getWeatherIconUrl() -> String {
        return weatherIconUrl[0]["value"] ?? ""
    }
    
    
}
