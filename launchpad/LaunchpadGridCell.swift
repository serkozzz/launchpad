//
//  LaunchpadCell.swift
//  launchpad
//
//  Created by Sergey Kozlov on 05.03.2025.
//

import UIKit

class LaunchpadGridCell: UICollectionViewCell {
    static let reuseID = "LaunchpadGridCell"
    struct Configuration {
        var color: UIColor
    }
    
    func configure(_ conf: Configuration) {
        self.backgroundColor = conf.color
    }
}
