//
//  countriesService.swift
//  Weather
//
//  Created by Ingy Salah on 11/20/21.
//

import Foundation

protocol CountriesApiProtocol: AnyObject {
    func countries(countries: [Country])
    func countriesFailed(error: BaseError)
    func countryFlag(flagString: String)
    func countryFlagFailed(error: BaseError)
}

class CountriesApi {
    
    weak var delegate: CountriesApiProtocol!
    var countriesDataTask: URLSessionDataTask!

    init(delegate: CountriesApiProtocol) {
        self.delegate = delegate
    }
    
    func getCountries() {
        let url = Configuration.countriesDomain
        var req = URLRequest(url: URL(string: url)!)
        req.httpMethod = "GET"
        countriesDataTask = Http.shared.makeNewRequest(req: req, completion: { [self] data in
    
            guard let data = data, let countriesApiData = CountriesApiData.fromData(data: data) else {
                self.delegate?.countriesFailed(error: BaseError(errorCode: .ParsingError))
                return
            }
            
            self.delegate?.countries(countries: countriesApiData.data)
            
        }, failure: { error in
            self.delegate?.countriesFailed(error: error)
        })
        countriesDataTask.resume()
    }
    
    
    func getCountryFlag(country: String) {
        let url = "\(Configuration.countriesDomain)/flag/unicode"
        var req = URLRequest(url: URL(string: url)!)
        
        let json: [String: Any] = ["country": country]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        req.httpBody = jsonData
        
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpMethod = "POST"
        countriesDataTask = Http.shared.makeNewRequest(req: req, completion: { [self] data in
    
            guard let data = data else {
                self.delegate?.countryFlagFailed(error: BaseError(errorCode: .ParsingError))
                return
            }
        
            do {
                let dict = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                let data = dict["data"] as! [String: Any]
                let imageString = data["unicodeFlag"] as! String
                delegate?.countryFlag(flagString: imageString)
            } catch {}
            
            
        }, failure: { error in
            self.delegate?.countryFlagFailed(error: error)
        })
        countriesDataTask.resume()
    }

}
