//
//  Location.swift
//  Weather
//
//  Created by Toby Patton on 29/4/2022.
//

import UIKit

//This is a struct for location data for when the user taps on each location in the list
struct Location: Codable, Equatable {
    let name: String
    let lat: Double
    let lon: Double
    
    //This func stores the data of the location when the user taps the favourite button (the star)
    //It allows us to recall this information even if the app has been shutdown.
    //It is this that allows us to recall the location and jump to it on app launch
    static func stored() -> Location? {
        guard let data = UserDefaults.standard.data(forKey: "cityName") else {
            return nil
        }
        return try? JSONDecoder().decode(Location.self, from: data)
    }
    
    var data: Data? {
        return try? JSONEncoder().encode(self)
    }
}
