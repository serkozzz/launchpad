//
//  LanchpadGridCellContentConfiguration.swift
//  launchpad
//
//  Created by Sergey Kozlov on 06.03.2025.
//
import UIKit


//ContentConfiguration абсолютно не нужен здесь, просто набиваем руку
struct LaunchpadGridCellContentConfiguration: UIContentConfiguration {
    
    var pad: LaunchpadPad
    var editMode: Bool
    
    func makeContentView() -> any UIView & UIContentView {
        return LaunchpadGridCellContentView(self)
    }
    
    func updated(for state: any UIConfigurationState) -> LaunchpadGridCellContentConfiguration {
        self
    }
}
