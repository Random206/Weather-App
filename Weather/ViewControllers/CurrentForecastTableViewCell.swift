//
//  CurrentForecastTableViewCell.swift
//  Weather
//
//  Created by Toby Patton on 29/4/2022.
//

import Foundation
import UIKit

//Defining the IBOutlets that the WeatherViewController uses to display the weather data
final class CurrentForecastTableViewCell: UITableViewCell {
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var mainLabel: UILabel!
    
    override func prepareForReuse() {
        weatherIconImageView.transform = CGAffineTransform(rotationAngle: 0)
    }

}
