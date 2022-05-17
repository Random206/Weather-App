    //
    //  CurrentForecaseTableViewCell.swift
    //  WeatherApp
    //
    //  Created by Beau Nouvelle on 2020-10-19.
    //

import Foundation
import UIKit

final class CurrentForecastTableViewCell: UITableViewCell {
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var windDirectionLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
}
