//
//  HomeTableViewPresenter.swift
//  Weather
//
//  Created by Ingy Salah on 11/20/21.
//

protocol HomeTableViewProtocol: AnyObject {
    func showCitiesList(cities: [City])
    func showNoCitiesAlert()
    func openCitiesTableView()
    func reloadTableView(city: City)
    func openWeatherViewController(city: City)
}

class HomeTableViewPresenter {

    weak var view: HomeTableViewProtocol!
    var userCitiesList: [City] = []
    
    init(view: HomeTableViewProtocol) {
        self.view = view
    }
    
    func onLoad() {
        getUserCitiesList()
        
        if !self.userCitiesList.isEmpty {
            view.showCitiesList(cities: self.userCitiesList)
        } else {
            view.showNoCitiesAlert()
        }
    }
    
    func getUserCitiesList() {
        if let userCitiesList = LocalStorage.userCitiesList {
            self.userCitiesList = userCitiesList
        }
    }
    
    func onAddButtonClick() {
        view.openCitiesTableView()
    }
    
    func onDeleteCity(citiesList: [City]){
        LocalStorage.userCitiesList = citiesList
        if citiesList.count == 0 {
            view.showNoCitiesAlert()
        }
    }
    
    func onSelectingCity(city: City) {
        view.openWeatherViewController(city: city)
    }
    
    
}

extension HomeTableViewPresenter: CitiesViewControllerDelegate {
    
    func onCitySelected(city: City) {
        userCitiesList.append(city)
        LocalStorage.userCitiesList = userCitiesList
        view.reloadTableView(city: city)
    }

}
