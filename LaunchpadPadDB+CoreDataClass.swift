//
//  LaunchpadPadDB+CoreDataClass.swift
//  launchpad
//
//  Created by Sergey Kozlov on 09.03.2025.
//
//

import Foundation
import CoreData

@objc(LaunchpadPadDB)
public class LaunchpadPadDB: NSManagedObject {
    var isActive: Bool = false
    var number: Int = 0
}
