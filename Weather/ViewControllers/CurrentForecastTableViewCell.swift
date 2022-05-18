//
//  CurrentForecastTableViewCell.swift
//  Weather
//
//  Created by Toby Patton on 29/4/2022.
//

import Foundation
import UIKit

final class CurrentForecastTableViewCell: UITableViewCell {
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var windDirectionLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    
    override func prepareForReuse() {
        weatherIconImageView.transform = CGAffineTransform(rotationAngle: 0)
    }

}
