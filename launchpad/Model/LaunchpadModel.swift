//
//  LaunchpadModel.swift
//  launchpad
//
//  Created by Sergey Kozlov on 05.03.2025.
//

import CoreData

class LaunchpadModel {
    static private(set) var shared = LaunchpadModel()
    var grid = LaunchpadGridModel()
    var instrumetns: [InstrumentDB] {
        return fetchInstruments()
    }

    private func fetchInstruments() -> [InstrumentDB] {
        let fetchRequest: NSFetchRequest<InstrumentDB> = InstrumentDB.fetchRequest()
        let instruments = try! CoreDataStack.shared.managedContext.fetch(fetchRequest)
        return instruments
    }
}
