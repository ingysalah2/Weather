//
//  CitiesTableViewPresenter.swift
//  Weather
//
//  Created by Ingy Salah on 11/20/21.
//

import Foundation

protocol CitiesTableViewProtocol: AnyObject {
    func reloadTableViewWith(countries: [Country])
    func dismissView()
    func onSearchFinish(filteredCountries: [Country])
    func onCountriesFail(error: BaseError)
    func onFlagFail(error: BaseError)
}

protocol CitiesViewControllerDelegate: AnyObject {
    func onCitySelected(city: City)
}

class CitiesTableViewPresenter {

    weak var view: CitiesTableViewProtocol!
    weak var delegate: CitiesViewControllerDelegate!
    var countriesApi: CountriesApi!
    var selectedCity: String!
    var selectedCountry: String!
    var countries: [Country] = []
    var filteredCountries: [Country] = []
    
    init(view: CitiesTableViewProtocol, delegate: CitiesViewControllerDelegate) {
        self.view = view
        self.delegate = delegate
        countriesApi = CountriesApi(delegate: self)
    }
    
    func onLoad() {
        countriesApi.getCountries()
    }
    
    func onCitySelected(city: String, country: String) {
        selectedCity = city
        selectedCountry = country
    }
    
    func onCloseButtonClick() {
        view.dismissView()
    }
    
    func onDoneButtonClick() {
        if let selectedCountry = selectedCountry{
            countriesApi.getCountryFlag(country: selectedCountry)
        } else {
            view.dismissView()
        }
    }
    
    func onSearch(text: String) {
        filteredCountries.removeAll()
        for country in countries {
            if country.country.lowercased().contains(text) {
                filteredCountries.append(country)
            }
        }
        view.onSearchFinish(filteredCountries: filteredCountries)
    }
    
    func onSearchEnded(){
        view.reloadTableViewWith(countries: countries)
    }
     
    
}

extension CitiesTableViewPresenter: CountriesApiProtocol {
    func countryFlag(flagString: String) {
        DispatchQueue.main.async {
            let city = City(name: self.selectedCity, country: self.selectedCountry, imageString: flagString )
            self.delegate.onCitySelected(city: city)
            self.view.dismissView()
        }
    }
    
    func countryFlagFailed(error: BaseError) {
        DispatchQueue.main.async {
            self.view.onFlagFail(error: error)
        }
    }
    
    
    func countriesFailed(error: BaseError) {
        DispatchQueue.main.async {
            self.view.onCountriesFail(error: error)
        }
    }

    func countries(countries: [Country]) {
        DispatchQueue.main.async {
            self.countries = countries
            self.view.reloadTableViewWith(countries: countries)
        }
    }
    

}
