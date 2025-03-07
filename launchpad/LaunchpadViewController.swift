//
//  LaunchpadViewController.swift
//  launchpad
//
//  Created by Sergey Kozlov on 05.03.2025.
//

import UIKit

class LaunchpadViewController: UIViewController {
    

    @IBAction func minus(_ sender: Any) {
        LaunchpadModel.shared.grid.decreaseGrid()
    }
    @IBAction func plus(_ sender: Any) {
        LaunchpadModel.shared.grid.increaseGrid()
    }
}
