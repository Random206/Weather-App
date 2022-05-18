//
//  Forecast.swift
//  Weather
//
//  Created by Toby Patton on 29/4/2022.
//

import Foundation

struct Forecast: Decodable {

    // Creating the constants and their casting
    let dt: TimeInterval
    let sunrise: TimeInterval
    let sunset: TimeInterval
    let temp: Double
    let weather: [Weather]
    let daily: [Daily]
    let hourly: [Hourly]

    // Creating an enum called CodingKeys that holds strings to ensure the same terms are used each time
    // This helps to avoid human error and ensures uniformity and ease of use with repetitive terms
    enum CodingKeys: String, CodingKey {
        case current
        case daily
        case hourly

        case dt
        case sunrise
        case sunset
        case temp
        case weather
    }

    //This is what the weather API will use to create a Forecast struct
    //The JSON data is parsed through to the struct through this init
    init(from decoder: Decoder) throws {
        let root = try decoder.container(keyedBy: CodingKeys.self)
        daily = try root.decode([Daily].self, forKey: .daily)
        hourly = try root.decode([Hourly].self, forKey: .hourly)

        let currentContainer = try root.nestedContainer(keyedBy: CodingKeys.self, forKey: .current)
        dt = try currentContainer.decode(TimeInterval.self, forKey: .dt)
        sunrise = try currentContainer.decode(TimeInterval.self, forKey: .sunrise)
        sunset = try currentContainer.decode(TimeInterval.self, forKey: .sunset)
        temp = try currentContainer.decode(Double.self, forKey: .temp)
        weather = try currentContainer.decode([Weather].self, forKey: .weather)
    }
}

//A Struct for Temp
struct Temp: Decodable {
    let min: Double
    let max: Double
}
//A Struct for Hourly forecasts
struct Hourly: Decodable {
    let temp: Double
    let weather: [Weather]
    let dt: Date
}
//A Struct for Daily forecasts
struct Daily: Decodable {
    let weather: [Weather]
    let temp: Temp
}
//A Struct for Weather
struct Weather: Decodable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}
