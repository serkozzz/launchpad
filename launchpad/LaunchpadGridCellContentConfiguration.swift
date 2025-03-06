//
//  LanchpadGridCellContentConfiguration.swift
//  launchpad
//
//  Created by Sergey Kozlov on 06.03.2025.
//
import UIKit

struct LaunchpadGridCellContentConfiguration: UIContentConfiguration {
    
    var pad: LaunchpadPad
    
    func makeContentView() -> any UIView & UIContentView {
        return LaunchpadGridCellContentView(self)
    }
    
    func updated(for state: any UIConfigurationState) -> LaunchpadGridCellContentConfiguration {
        self
    }
}
