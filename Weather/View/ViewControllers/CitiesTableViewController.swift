//
//  CitiesTableViewController.swift
//  Weather
//
//  Created by Ingy Salah on 11/20/21.
//

import UIKit

class CitiesTableViewController: UIViewController {


    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var citiesTableView: UITableView!
    @IBOutlet weak var doneActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var searchTextField: UITextField!
    
    var countries: [Country] = []
    
    var presenter: CitiesTableViewPresenter!
    var delegate: CitiesViewControllerDelegate!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = CitiesTableViewPresenter(view: self, delegate: delegate)
        presenter?.onLoad()
        setUpSearchTextField()
    }
    
    func setUpSearchTextField() {
        searchTextField.delegate = self
        searchTextField.addTarget(self, action: #selector(searchCities), for: .editingChanged)
    }
    
    @objc func searchCities(sender: UITextField) {
        let searchData = searchTextField.text!.count
        if searchData != 0 {
            presenter.onSearch(text: searchTextField.text!)
        } else {
            presenter.onSearchEnded()
        }
        
    }
    
    @IBAction func onCloseButtonClick(_ sender: Any) {
        presenter.onCloseButtonClick()
    }
    
    @IBAction func onDoneButtonClick(_ sender: Any) {
        doneActivityIndicator.startAnimating()
        presenter.onDoneButtonClick()
    }
    
    func showErrorAlert(error: BaseError) {
        let alert = UIAlertController(title: "Error", message: error.description, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
}

extension CitiesTableViewController: CitiesTableViewProtocol {
    
    func reloadTableViewWith(countries: [Country]) {
        activityIndicator.stopAnimating()
        self.countries = countries
        citiesTableView.reloadData()
    }
    
    func dismissView() {
        doneActivityIndicator.stopAnimating()
        dismiss(animated: true, completion: nil)
    }
    
    func onSearchFinish(filteredCountries: [Country]) {
        countries = filteredCountries
        citiesTableView.reloadData()
    }
    
    func onCountriesFail(error: BaseError) {
        activityIndicator.stopAnimating()
        showErrorAlert(error: error)
    }
    
    func onFlagFail(error: BaseError) {
        doneActivityIndicator.stopAnimating()
        showErrorAlert(error: error)
    }
    
    
}

extension CitiesTableViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
}

extension CitiesTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return countries.count
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let sectionView = UIView()
        sectionView.backgroundColor = .white
        let button = UIButton(type: .system)
        button.setTitle(countries[section].country, for: .normal)
        button.tag = section
        button.addTarget(self, action: #selector(handleExpandClose), for: .touchUpInside)
        button.contentHorizontalAlignment = .left
        button.setTitleColor(.black, for: .normal)
        button.frame = CGRect(x: 40, y: 5, width: 400, height: 40)
        sectionView.addSubview(button)
        
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 5, y: 5, width: 25, height: 25)
        sectionView.addSubview(imageView)
        return sectionView
        
    }
    
    @objc func handleExpandClose(button: UIButton) {
        let section = button.tag
        var indexPaths = [IndexPath]()
        for row in countries[section].cities.indices {
            let indexPath = IndexPath(row: row, section: section)
            indexPaths.append(indexPath)
        }

        let isExpanded = countries[section].isExpanded
        countries[section].isExpanded = !isExpanded
        
        if isExpanded {
            citiesTableView.deleteRows(at: indexPaths, with: .fade)
        } else {
            citiesTableView.insertRows(at: indexPaths, with: .fade)
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !countries[section].isExpanded {
            return 0
        }
        return countries[section].cities.count
    }
    
     
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityTableViewCell", for: indexPath) as! CityTableViewCell
        
        let country = countries[indexPath.section]
        let city = country.cities[indexPath.row]
        cell.setData(city: city)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = citiesTableView.cellForRow(at: indexPath) as! CityTableViewCell
        presenter.onCitySelected(city: cell.cityNameLabel.text ?? "", country: countries[indexPath.section].country)
        
    }
    
}
