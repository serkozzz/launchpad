//
//  PadsAnimator.swift
//  launchpad
//
//  Created by Sergey Kozlov on 07.03.2025.
//

import Foundation
import CoreData

class PadsAnimator {
    
    private var animations: [NSManagedObjectID: Timer] = [:]
    
    func blink(padID: NSManagedObjectID, duration: TimeInterval = 0.1) {

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
