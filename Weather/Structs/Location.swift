//
//  Location.swift
//  Weather
//
//  Created by Toby Patton on 29/4/2022.
//

import UIKit

struct Location: Codable, Equatable {
    let name: String
    let lat: Double
    let lon: Double
    
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
