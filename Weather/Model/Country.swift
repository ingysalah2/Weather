//
//  Country.swift
//  Weather
//
//  Created by Ingy Salah on 11/20/21.
//

import Foundation
import UIKit

class Country: Codable {
    
    var country: String!
    var cities: [String]!
    var isExpanded: Bool = false
    
    required init(from decoder: Decoder) throws {
        do  {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.isExpanded = try container.decodeIfPresent(Bool.self, forKey: .isExpanded) ?? false
            self.country = try container.decodeIfPresent(String.self, forKey: .country)
            self.cities = try container.decodeIfPresent([String].self, forKey: .cities)
        }
        catch {
            print(error)
        }
    }
}

class CountriesApiData: Codable {

    var data: [Country]
    
}


