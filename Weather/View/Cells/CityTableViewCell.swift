//
//  CityTableViewCell.swift
//  Weather
//
//  Created by Ingy Salah on 11/20/21.
//

import UIKit

class CityTableViewCell: UITableViewCell {

    @IBOutlet weak var cityNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    func setData(city: String) {
        cityNameLabel.text = city
    }

}
