//
//  WeatherViewPresenter.swift
//  Weather
//
//  Created by Ingy Salah on 11/20/21.
//

import Foundation

protocol WeatherViewProtocol: AnyObject {
    func onWeatherReady(weather: CityWeather)
    func onWeatherFail(error: BaseError)
}

class WeatherViewPresenter {

    weak var view: WeatherViewProtocol!
    var weatherApi: WeatherApi!
    
    init(view: WeatherViewProtocol) {
        self.view = view
        weatherApi = WeatherApi(delegate: self)
    }
    
    func onLoad(city: City) {
        weatherApi.getWeather(cityName: city.name)
        
    }

}

extension WeatherViewPresenter: WeatherApiProtocol {
    func weather(weather: CityWeather) {
        DispatchQueue.main.async {
            self.view.onWeatherReady(weather: weather)
        }
    }
    
    func weatherFailed(error: BaseError) {
        DispatchQueue.main.async {
            self.view.onWeatherFail(error: error)
        }
    }
    

}
