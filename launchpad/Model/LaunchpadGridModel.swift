//
//  LaunchpadGridModel.swift
//  launchpad
//
//  Created by Sergey Kozlov on 05.03.2025.
//

import Foundation
import Combine
import CoreData

let GRID_MAX_COLUMNS = 5
let GRID_MIN_COLUMNS = 2
let GRID_MAX_ROWS = 5
let GRID_MIN_ROWS = 2
let GRID_DEFAULT_COLUMNS = 3
let GRID_DEFAULT_RAWS = 3



class LaunchpadGridModel {
    
    private(set) var columns = GRID_DEFAULT_COLUMNS {
        didSet { columnsChanged.send(columns) }
    }
    private(set) var rows = GRID_DEFAULT_RAWS {
        didSet { rowsChanged.send(rows) }
    }

    
    
    private var allPads = [LaunchpadPadDB]()
    
    var visiblePads: [LaunchpadPad] {
        get {
            var result = [LaunchpadPad]()
            for i in 0..<rows {
                let start = i * GRID_MAX_COLUMNS
                result += allPads[start..<(start + columns)].map { LaunchpadPad($0)}
            }
            return result
        }
    }
    
    subscript(row: Int, column: Int) -> LaunchpadPad {
        get {
            let index = row * GRID_MAX_COLUMNS + column
            return LaunchpadPad(allPads[index])
        }
//        set {
//            let index = row * GRID_MAX_COLUMNS + column
//        }
    }
    
    private var counter = 0
    init () {
        allPads = fetchPads()
    }
    
    private func fetchPads() -> [LaunchpadPadDB] {
        let fetchRequest: NSFetchRequest<LaunchpadPadDB> = LaunchpadPadDB.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "order", ascending: true)]
        let pads = try! CoreDataStack.shared.managedContext.fetch(fetchRequest)
        return pads
    }
    
    private func fetchInstruments() -> [InstrumentDB] {
        let fetchRequest: NSFetchRequest<InstrumentDB> = InstrumentDB.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        let instruments = try! CoreDataStack.shared.managedContext.fetch(fetchRequest)
        return instruments
    }
    
    func increaseGrid() {
        guard columns + 1 <= GRID_MAX_COLUMNS, rows + 1 <= GRID_MAX_ROWS else { return }
        columns += 1
        rows += 1
    }
    
    func decreaseGrid() {
        guard columns - 1 >= GRID_MIN_COLUMNS, rows - 1 >= GRID_MIN_ROWS else { return }
        columns -= 1
        rows -= 1
    }
    
    func togglePad(_ id: NSManagedObjectID) {
        let index = allPadsIndex(for: id)
        allPads[index].isActive.toggle()
        padActivityChanged.send(id)
    }
    
    func setInstrument(_ instrumentID: NSManagedObjectID, for padID: NSManagedObjectID) {
        let instumentDB = fetchInstruments().first(where: {$0.objectID == instrumentID})!
        let padDB = allPads.first(where: {$0.objectID == padID})!
        padDB.instrument = instumentDB
        CoreDataStack.shared.saveContext()
        
        padInstrumentChanged.send(padID)
    }
    
    func pad(for id: NSManagedObjectID) -> LaunchpadPad {
        let padDB = allPads.first(where: { $0.objectID == id})!
        return LaunchpadPad(padDB)
    }
    
    private func allPadsIndex(for id: NSManagedObjectID) -> Int {
        return allPads.firstIndex(where: {$0.objectID == id})!
    }
//    
//    private func padCoords(for id: UUID) -> (Int, Int) {
//        for i in 0..<rows {
//            for j in 0..<columns {
//                if self[i, j].id == id {
//                    return (i, j)
//                }
//            }
//        }
//        fatalError("padCoords: id is not on the grid")
//    }

    
    var columnsChanged = PassthroughSubject<Int, Never>()
    var rowsChanged = PassthroughSubject<Int, Never>()
    var padActivityChanged = PassthroughSubject<NSManagedObjectID, Never>()
    var padInstrumentChanged = PassthroughSubject<NSManagedObjectID, Never>()
}


