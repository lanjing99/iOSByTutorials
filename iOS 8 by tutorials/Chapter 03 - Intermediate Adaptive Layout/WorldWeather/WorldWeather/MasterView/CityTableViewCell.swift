//
//  CityTableViewCell.swift
//  WorldWeather
//
//  Created by lanjing on 2/25/16.
//  Copyright © 2016 RayWenderlich. All rights reserved.
//

import UIKit

class CityTableViewCell: UITableViewCell {

    // MARK: - IBOutlets
    
    @IBOutlet weak var cityImageView: UIImageView!
    @IBOutlet weak var cityNameLabel: UILabel!
    
    // MARK: - Properties
    var cityWeather: CityWeather? {
        didSet {
        configureCell()
        }
    }
    // MARK: - Utility methods
    private func configureCell() {
        cityImageView.image = cityWeather?.cityImage
        cityNameLabel.text = cityWeather?.name
    }

}
