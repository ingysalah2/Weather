//
//  CurrentWeather.swift
//  Weather
//
//  Created by Ingy Salah on 11/21/21.
//

import Foundation

class CurrentWeather: Codable {
    
    var temp_C: String!
    var FeelsLikeC: String!
    var windspeedKmph: String!
    var weatherDesc: [[String:String]]!
    var humidity: String!
    var weatherIconUrl: [[String:String]]!
    
    
    func weatherDescString() -> String {
        return weatherDesc[0]["value"] ?? ""
    }
    
    func getWeatherIconUrl() -> String {
        return weatherIconUrl[0]["value"] ?? ""
    }
    
    
}
