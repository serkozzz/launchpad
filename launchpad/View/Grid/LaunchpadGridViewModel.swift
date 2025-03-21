//
//  LaunchpadManager.swift
//  launchpad
//
//  Created by Sergey Kozlov on 08.03.2025.
//

import UIKit
import Combine
import CoreData

class LaunchpadGridViewModel {
    enum LaunchpadChange {
        case collectionUpdated
        case padUpdated 
    }
    
    var onUpdate: ((LaunchpadChange) -> Void)?
    
    private(set) var snapshot = NSDiffableDataSourceSnapshot<Int, NSManagedObjectID>()
    private var gridModel = LaunchpadModel.shared.grid
    private var cancellables: Set<AnyCancellable> = []
    
    init() {

        recreateSnapshot()
        gridModel.columnsChanged.sink { [weak self] _ in
            guard let self else { return }
            recreateSnapshot()
            onUpdate?(.collectionUpdated)
        }.store(in: &cancellables)
        
        gridModel.rowsChanged.sink { [weak self] _ in
            guard let self else { return }
            recreateSnapshot()
            onUpdate?(.collectionUpdated)
        }.store(in: &cancellables)
        
        gridModel.padActivityChanged.sink { [weak self] id in
            guard let self else { return }
            recreateSnapshot()
            snapshot.reloadItems([id])
            onUpdate?(.padUpdated)
        }.store(in: &cancellables)
        
        gridModel.padInstrumentChanged.sink { [weak self] id in
            guard let self else { return }
            recreateSnapshot()
            snapshot.reloadItems([id])
            onUpdate?(.padUpdated)
        }.store(in: &cancellables)
    }
    
    func recreateSnapshot() {
        snapshot = NSDiffableDataSourceSnapshot<Int, NSManagedObjectID>()
        snapshot.appendSections([0])
        snapshot.appendItems(gridModel.visiblePads.map { $0.id })

    }
    
    func setInstrument(_ instrumentID: NSManagedObjectID, for padID: NSManagedObjectID) {
        gridModel.setInstrument(instrumentID, for: padID)
    }
    
    func pad(for id: NSManagedObjectID) -> LaunchpadPad {
        gridModel.pad(for: id)
    }
    
    var columns: Int {
        gridModel.columns
    }
    
    var rows: Int {
        gridModel.rows
    }
}
