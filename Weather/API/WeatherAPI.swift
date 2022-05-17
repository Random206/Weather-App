//
//  WeatherAPI.swift
//  Weather
//
//  Created by Toby Patton on 29/4/2022.
//

import Foundation

class WeatherAPI {
    
    let baseUrl = URL(string: "https://api.openweathermap.org/data/2.5/onecall")!
    
    func getWeather(for city: Location, completion: @escaping (Result<Forecast, Error>) -> ()) {
        var urlComponents = URLComponents(url: baseUrl, resolvingAgainstBaseURL: true)
        
            //        #warning("Replace Your Key")
        let queries = [URLQueryItem(name: "lat", value: "\(city.lat)"),
                       URLQueryItem(name: "lon", value: "\(city.lon)"),
                       URLQueryItem(name: "appid", value: "505d56233b03b6f23ec795535acd81e8")]
        
        urlComponents?.queryItems = queries
        
        guard let url = urlComponents?.url else {
            print("Could not create url")
            return
        }
        
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let validData = data else {
                print("no data")
                return
            }
            DispatchQueue.main.async {
                do {
                    let weather = try JSONDecoder().decode(Forecast.self, from: validData)
                    completion(.success(weather))
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        .resume()
    }
}
