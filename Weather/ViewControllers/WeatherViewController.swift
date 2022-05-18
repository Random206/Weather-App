//
//  WeatherViewController.swift
//  Weather
//
//  Created by Toby Patton on 29/4/2022.
//

import Foundation
import UIKit

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    //creating the variables and constants
    let api = WeatherAPI()
    var forecast: Forecast?
    var city: Location?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Setting the delegate and dataSource
        tableView.delegate = self
        tableView.dataSource = self
        //Setting the title to the city name
        title = city?.name
        tableView.register(HourlyTableViewCell.self, forCellReuseIdentifier: "CELL")
        //Setting the table row height to automatic to fit the data in properly
        tableView.rowHeight = UITableView.automaticDimension
        
        //Defining the favButton as a star
        let favButton = UIBarButtonItem(image: UIImage(systemName: "star"), style: .plain, target: self, action: #selector(favButtonTapped))
        //Setting the rightBarButtonItem to the favButton (the star)
        navigationItem.rightBarButtonItem = favButton
        //Calling the updateFavButton function (Below)
        updateFavButton()
    }
    
    @objc func favButtonTapped() {
        //Checking if we have a stored location and if it's the current showing location then sets the favButton to filled
        //Otherwise set the button to empty
        //Without this function, the button will always show as unfilled or filled and there would be no alternate state when the button is tapped
        if Location.stored() == city {
            UserDefaults.standard.setValue(nil, forKey: "cityName")
            navigationItem.rightBarButtonItem?.image = UIImage(systemName: "star.fill")
        } else {
            UserDefaults.standard.setValue(city?.data, forKey: "cityName")
            navigationItem.rightBarButtonItem?.image = UIImage(systemName: "star")
        }
        //Updating the favButton to reflect the current required state
        updateFavButton()
    }
    
    private func updateFavButton() {
        //Checking if there is a stored location and if there is then we set the button to filled
        //Otherwise we set the rightBarButtonItem to an empty star
        if Location.stored() == city {
            navigationItem.rightBarButtonItem?.image = UIImage(systemName: "star.fill")
        } else {
            navigationItem.rightBarButtonItem?.image = UIImage(systemName: "star")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Calling the loadData function to prepare the viewController for when it loads
        loadData()
    }
    
    func loadData() {
        //Unwrapping the City data for use in calling the API
        guard let unwrappedCity = city else {
            return
        }
        //Calling the API and checking for it's result success or failure
        //If there is a failure we break
        //If there is a success we reload the table to show the data
        api.getWeather(for: unwrappedCity) { [weak self] result in
            switch result {
                case .failure:
                    break
                case .success(
                    let forecast): self?.forecast = forecast
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                    break
            }
        }
    }
    
}

extension WeatherViewController: UITableViewDataSource {
    //Defining the function for creating the Hourly Forecast table view
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "Hourly Forecast"
        }
        return nil
    }
    
    //Defining the dimensions of the tableView for section 1 and section 0
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return 100
        }
        
        if indexPath.section == 0 {
            return 100
        }
        return UITableView.automaticDimension
    }
    
    //Defining the number of sections to 2 for Hourly and Current
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    //Defining the number of rows to 1 for any passed in section number (they all only need 1 row)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Section 0
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CurrentCell", for: indexPath) as! CurrentForecastTableViewCell
            //Setting the values in the View Controller to show the user the weather and temp
            cell.temperatureLabel.text = "\(forecast?.temp ?? -99999)"
            cell.mainLabel.text = "\(forecast?.weather.first?.main ?? "")"
            cell.weatherIconImageView?.image = UIImage(named: forecast?.weather.first?.icon ?? "01d")
            cell.weatherIconImageView.layer.cornerRadius = 5
            
            UIView.animate(withDuration: 5) {
                cell.weatherIconImageView.transform = CGAffineTransform(rotationAngle: .pi)
            }
            
            return cell
        } else if indexPath.section == 1 {
            let cell = HourlyTableViewCell(hourly: forecast?.hourly)
            return cell
        }
        
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
}

extension WeatherViewController: UITableViewDelegate {
    
}
