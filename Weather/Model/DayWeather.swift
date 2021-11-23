//
//  DayWeather.swift
//  Weather
//
//  Created by Ingy Salah on 11/21/21.
//

import Foundation

class DayWeather: Codable {
    
    var date: String!
    var mintempC: String!
    var maxtempC: String!
    var hourly: [HourlyWeather]!
    
}
