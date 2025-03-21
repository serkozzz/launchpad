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
    var id: NSManagedObjectID
    var instrumentID: NSManagedObjectID?
    
    init (_ padDB: LaunchpadPadDB) {
        isActive = padDB.isActive
        id = padDB.objectID
        instrumentID = padDB.instrumentId?.toManagedObjectID(context: CoreDataStack.shared.managedContext)
    }
}
