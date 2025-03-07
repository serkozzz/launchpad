//
//  PadsAnimator.swift
//  launchpad
//
//  Created by Sergey Kozlov on 07.03.2025.
//

import Foundation

class PadsAnimator {
    
    private var animations: [UUID: Timer] = [:]
    
    func blink(padID: UUID, duration: TimeInterval = 0.1) {

        let grid = LaunchpadModel.shared.grid
        if (!grid.pad(for: padID).isActive) {
            grid.togglePad(padID)
        }
        animations[padID] = Timer.scheduledTimer(withTimeInterval: duration, repeats: false) { _ in
            let grid = LaunchpadModel.shared.grid
            grid.togglePad(padID)
        }
  
    }
}
