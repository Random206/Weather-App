//
//  HourlyCollectionViewCell.swift
//  Weather
//
//  Created by Toby Patton on 29/4/2022.
//

import Foundation
import UIKit

final class HourlyCollectionViewCell: UICollectionViewCell {
    var temperatureLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        contentView.addSubview(temperatureLabel)
        
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        temperatureLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
        temperatureLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
        temperatureLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        temperatureLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        temperatureLabel.numberOfLines = 0
        temperatureLabel.textAlignment = .right
        temperatureLabel.backgroundColor = .systemBackground
    }
}
