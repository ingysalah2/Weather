//
//  HourlyWeatherCollectionViewCell.swift
//  Weather
//
//  Created by Ingy Salah on 11/22/21.
//

import UIKit

class HourlyWeatherCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    func setupUI() {
        weatherImageView.layer.cornerRadius = 8
    }

    func setData(weather: HourlyWeather) {
        let hour = Int(weather.time)! / 100
        timeLabel.text = String(hour) + ":00"
        tempLabel.text = weather.tempC + "°"
        weatherImageView.downloaded(from: weather.getWeatherIconUrl())
    }

    
}
