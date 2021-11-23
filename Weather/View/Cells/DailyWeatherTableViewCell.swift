//
//  DailyWeatherTableViewCell.swift
//  Weather
//
//  Created by Ingy Salah on 11/22/21.
//

import UIKit

class DailyWeatherTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var lowTempLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var highTempLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    func setupUI() {
        weatherImageView.layer.cornerRadius = 8
    }

    func setData(dayWeather: DayWeather) {
        dateLabel.text = dayWeather.date
        lowTempLabel.text = dayWeather.mintempC + "°"
        highTempLabel.text = dayWeather.maxtempC + "°"
        weatherImageView.downloaded(from: dayWeather.hourly[12].getWeatherIconUrl())
    }

}
