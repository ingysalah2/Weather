//
//  HomeTableViewController.swift
//  Weather
//
//  Created by Ingy Salah on 11/20/21.
//

import UIKit

class HomeTableViewController: UIViewController {

    
    @IBOutlet weak var alertLabel: UILabel!
    @IBOutlet weak var citiesTableView: UITableView!
    
    var cities: [City] = []
    var selectedCity: City!
    
    var presenter: HomeTableViewPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = HomeTableViewPresenter(view: self)
        presenter?.onLoad()
    }
    
    @IBAction func onAddButtonClick(_ sender: Any) {
        presenter.onAddButtonClick()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToCitiesTableView" {
            if let citiesTableVC =  segue.destination as? CitiesTableViewController {
                citiesTableVC.delegate = presenter
            }
        }
        else if segue.identifier == "openWeather" {
            if let destinationVC = segue.destination as? WeatherViewController {
                destinationVC.city = selectedCity
            }
        }
    }
        
}

extension HomeTableViewController: HomeTableViewProtocol {
    func showCitiesList(cities: [City]) {
        self.cities = cities
        citiesTableView.reloadData()
    }
    
    func showNoCitiesAlert() {
        alertLabel.isHidden = false
        view.bringSubviewToFront(alertLabel)
    }
    
    func openCitiesTableView() {
        performSegue(withIdentifier: "goToCitiesTableView", sender: self)
    }
    
    func reloadTableView(city: City) {
        alertLabel.isHidden = true
        cities.append(city)
        citiesTableView.reloadData()
    }
    
    func openWeatherViewController(city: City) {
        selectedCity = city
        performSegue(withIdentifier: "openWeather", sender: self)
    }
    
    
}

extension HomeTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as! HomeTableViewCell
        
        let city = cities[indexPath.row]
        cell.setData(city: city)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            cities.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            presenter.onDeleteCity(citiesList: cities)
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.onSelectingCity(city: cities[indexPath.row])
    }
    
    
}
