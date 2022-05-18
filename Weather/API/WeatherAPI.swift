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
        
        //This is the URL items that are submitted with the name and the value
        //When added together this will create the URL that is called to communicate with the API
        let queries = [URLQueryItem(name: "lat", value: "\(city.lat)"),
                       URLQueryItem(name: "lon", value: "\(city.lon)"),
                       URLQueryItem(name: "appid", value: "505d56233b03b6f23ec795535acd81e8"),
                       URLQueryItem(name: "units", value: "metric")]
        
        urlComponents?.queryItems = queries
        
        //Tests the URL components are able to be created successfully or not
        guard let url = urlComponents?.url else {
            print("Could not create url")
            return
        }
        
        let request = URLRequest(url: url)
        //This part is what calls the API and tests whether the data returned was successful or returned with nothing
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let validData = data else {
                print("no data")
                return
            }
            //This is where the data is decoded and tests if it was decoded successfully or failed
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
