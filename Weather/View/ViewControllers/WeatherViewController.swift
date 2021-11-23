//
//  WeatherViewController.swift
//  Weather
//
//  Created by Ingy Salah on 11/20/21.
//

import UIKit

class WeatherViewController: UIViewController {


    @IBOutlet weak var currentWeatherView: UIView!
    @IBOutlet weak var hourlyForecastView: UIView!
    @IBOutlet weak var dailyForecastView: UIView!
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var weatherDescLabel: UILabel!
    @IBOutlet weak var moreInfoLabel: UILabel!
    @IBOutlet weak var currentWeatherImageView: UIImageView!
    @IBOutlet weak var dailyTableView: UITableView!
    @IBOutlet weak var hourlyWeatherCollectionView: UICollectionView!
    
    
    var city: City!
    var weather: CityWeather!
    var dailyWeathers: [DayWeather] = []
    var todayHourlyWeather: [HourlyWeather] = []
    var presenter: WeatherViewPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = WeatherViewPresenter(view: self)
        presenter.onLoad(city: city)
        setupUI()
    }
    
    func setupUI() {
        currentWeatherView.layer.cornerRadius = 20
        hourlyForecastView.layer.cornerRadius = 20
        dailyForecastView.layer.cornerRadius = 20
        currentWeatherImageView.layer.cornerRadius = 8
    }
    
    func setUpCurrentWeatherView() {
        let currentWeather = weather.getCurrentWeather()
        currentWeatherImageView.downloaded(from: currentWeather.getWeatherIconUrl())
        cityNameLabel.text = city.name + ", " + city.country
        currentTempLabel.text = currentWeather.temp_C + "°"
        feelsLikeLabel.text = "Feels like " + currentWeather.FeelsLikeC + "°"
        weatherDescLabel.text = currentWeather.weatherDescString()
        moreInfoLabel.text = "Humidity " + currentWeather.humidity + "    Wind " + currentWeather.windspeedKmph
       
        
    }

    @IBAction func onBackButtonClick(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}

extension WeatherViewController: WeatherViewProtocol {
    
    func onWeatherReady(weather: CityWeather) {
        self.weather = weather
        dailyWeathers = weather.weather
        todayHourlyWeather = dailyWeathers[0].hourly
        setUpCurrentWeatherView()
        dailyTableView.reloadData()
        hourlyWeatherCollectionView.reloadData()
    }
    
    func onWeatherFail(error: BaseError) {
        let alert = UIAlertController(title: "Error", message: error.description, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

}

extension WeatherViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dailyWeathers.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        let cell = tableView.dequeueReusableCell(withIdentifier: "DailyWeatherTableViewCell", for: indexPath) as! DailyWeatherTableViewCell
        
        let dayWeather = dailyWeathers[indexPath.row]
        cell.setData(dayWeather: dayWeather)
        
        return cell
    }
    
    
}

extension WeatherViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return todayHourlyWeather.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HourlyWeatherCollectionViewCell", for: indexPath) as! HourlyWeatherCollectionViewCell
        
        cell.setData(weather: todayHourlyWeather[indexPath.row])
        
        
        return cell
    }
    
    
}
