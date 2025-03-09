//
//  LaunchpadPad.swift
//  launchpad
//
//  Created by Sergey Kozlov on 09.03.2025.
//

import Foundation
import CoreData

struct LaunchpadPad {
    var isActive: Bool = false
    var number: Int = 0
    var id: NSManagedObjectID
    
    init (_ padDB: LaunchpadPadDB) {
        isActive = padDB.isActive
        number = Int(padDB.order)
        id = padDB.objectID
    }
}
