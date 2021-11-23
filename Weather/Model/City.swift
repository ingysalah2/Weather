//
//  City.swift
//  Weather
//
//  Created by Ingy Salah on 11/20/21.
//

import Foundation
import UIKit


class City: Codable {
    
    var name: String!
    var country: String!
    var imageString: String!
    
    init(name: String, country: String, imageString: String) {
        self.name = name
        self.country = country
        self.imageString = imageString
    }
    
}
