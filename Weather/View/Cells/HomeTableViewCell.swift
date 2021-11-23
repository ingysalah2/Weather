//
//  CityTableViewCell.swift
//  Weather
//
//  Created by Ingy Salah on 11/20/21.
//

import UIKit

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var cityImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    func setupUI() {
        cityImageView.layer.cornerRadius = cityImageView.frame.size.height / 2
        cardView.layer.cornerRadius = 15
        cardView.layer.borderColor = UIColor.lightGray.cgColor
        cardView.layer.borderWidth = 0.5
    }
    
    func setData(city: City) {
        cityImageView.image = city.imageString.image()
        nameLabel.text = city.name + ", " + city.country
    }
    
 
    
}
