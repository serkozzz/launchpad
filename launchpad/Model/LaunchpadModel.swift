//
//  LaunchpadModel.swift
//  launchpad
//
//  Created by Sergey Kozlov on 05.03.2025.
//

import CoreData

class LaunchpadModel {
    static private(set) var shared = LaunchpadModel()
    
    private(set) var grid = LaunchpadGridModel()
    private(set) var instrumentsLibrary = InstrumentsLibrary()
}
