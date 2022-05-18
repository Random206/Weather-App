//
//  CitySearchTableViewController.swift
//  Weather
//
//  Created by Toby Patton on 29/4/2022.
//

import UIKit
import MapKit

class citySearchTableViewController: UIViewController, UISearchBarDelegate, MKLocalSearchCompleterDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchResultsTable: UITableView!
    
    let API = WeatherAPI()
    
    var city: Location? {
        didSet {
            // do stuff here when City is updated.
            performSegue(withIdentifier: "showWeather", sender: self)
        }
    }
    
    // Create a seach completer object
    var searchCompleter = MKLocalSearchCompleter()
    
    // These are the results that are returned from the searchCompleter & what we are displaying
    // on the searchResultsTable
    var searchResults = [MKLocalSearchCompletion]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set up the delgates & the dataSources of both the searchbar & searchResultsTableView
        searchCompleter.delegate = self
        searchBar?.delegate = self
        searchResultsTable?.delegate = self
        searchResultsTable?.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            searchResultsTable.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height + searchResultsTable.rowHeight, right: 0)
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        searchResultsTable.contentInset = .zero
    }
    
    // This method declares that whenever the text in the searchbar is changed to also update
    // the query that the searchCompleter will search based off of
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchCompleter.queryFragment = searchText
        searchCompleter.region = MKCoordinateRegion(.world)
    }
    
    // This method declares what gets called whenever the searchCompleter has new search results
    // If you wanted to do any filter of the locations that are displayed on the the table view
    // this would be the place to do it.
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        // Setting our searcResults variable to the results that the searchCompleter returned
        searchResults = completer.results.filter { result in
            if !result.title.contains(",") {
                return false
            }
            if result.title.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil {
                return false
            }
            if result.subtitle.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil {
                return false
            }
            return true
        }
        
        // Reload the tableview with our new searchResults
        self.searchResults.sort(by: {$0.title < $1.title})
        searchResultsTable.reloadData()
    }
    
    // This method is called when there was an error with the searchCompleter
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        // Error
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let weatherVC = segue.destination as? WeatherViewController {
            weatherVC.city = city
        }
    }
}

// Setting up extensions for the table view
extension citySearchTableViewController: UITableViewDataSource {
    // This method declares the number of sections that we want in our table.
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // This method declares how many rows are the in the table
    // We want this to be the number of current search results that the Completer has generated for us
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    // This method delcares the cells that the table is going to show at a particular index
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Get the specific searchResult at the particular index
        let searchResult = searchResults[indexPath.row]
        
        //Create a new UITableViewCell object
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        
        //Set the content of the cell to our searchResult data
        cell.textLabel?.text = searchResult.title
        cell.detailTextLabel?.text = searchResult.subtitle
        return cell
    }
}

extension citySearchTableViewController: UITableViewDelegate {
    // This method declares the behavior of what is to happen when the row is selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let result = searchResults[indexPath.row]
        let searchRequest = MKLocalSearch.Request(completion: result)
        
        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            guard let coordinate = response?.mapItems[0].placemark.coordinate else {
                return
            }
            
            guard let name = response?.mapItems[0].name else {
                return
            }
            
            let city = Location(name: name, lat: coordinate.latitude, lon: coordinate.longitude)
            print("name: \(city.name)")
            print("lat: \(city.lat)")
            print("lon: \(city.lon)")
            
            self.city = city
        }
    }
}
