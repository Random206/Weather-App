    //
    //  HourlyTableviewCell.swift
    //  WeatherApp
    //
    //  Created by Beau Nouvelle on 2020-10-08.
    //

import Foundation
import UIKit

final class HourlyTableViewCell: UITableViewCell {
    
    var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    var hourly: [Hourly]?
    
    init(hourly: [Hourly]?) {
        self.hourly = hourly
        super.init(style: .default, reuseIdentifier: nil)
        setupSubviews()
        collectionView.reloadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 100, height: 100)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        contentView.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        
        collectionView.register(HourlyCollectionViewCell.self, forCellWithReuseIdentifier: "HourlyCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
    }
}

extension HourlyTableViewCell: UICollectionViewDelegate {
    
}

extension HourlyTableViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hourly?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HourlyCollectionViewCell", for: indexPath) as? HourlyCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let hour = hourly?[indexPath.row]
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        cell.temperatureLabel.text = dateFormatter.string(from: hour!.dt)
        
        return cell
    }
}
