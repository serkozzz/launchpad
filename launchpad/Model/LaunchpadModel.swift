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
    private lazy var instrumentsDB: [InstrumentDB] = fetchInstruments()
    
    var instrumetns: [Instrument] {
        return instrumentsDB.map { Instrument($0) }
    }

    func instrument(for id: NSManagedObjectID) -> Instrument {
        Instrument(instrumentsDB.first(where: {id == $0.objectID})!)
    }
    
    private func fetchInstruments() -> [InstrumentDB] {
        let fetchRequest: NSFetchRequest<InstrumentDB> = InstrumentDB.fetchRequest()
        let instruments = try! CoreDataStack.shared.managedContext.fetch(fetchRequest)
        return instruments
    }
}
