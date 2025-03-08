//
//  LaunchpadManager.swift
//  launchpad
//
//  Created by Sergey Kozlov on 08.03.2025.
//

import UIKit
import Combine

class LaunchpadManager {
    var onUpdate: (() -> Void)?
    
    private(set) var snapshot = NSDiffableDataSourceSnapshot<Int, UUID>()
    private var gridModel = LaunchpadModel.shared.grid
    private var cancellables: Set<AnyCancellable> = []
    
    init() {

        recreateSnapshot()
        gridModel.columnsChanged.sink { [weak self] _ in
            guard let self else { return }
            recreateSnapshot()
            onUpdate?()
        }.store(in: &cancellables)
        
        gridModel.rowsChanged.sink { [weak self] _ in
            guard let self else { return }
            recreateSnapshot()
            onUpdate?()
        }.store(in: &cancellables)
        
        gridModel.padChanged.sink { [weak self] id in
            guard let self else { return }
            recreateSnapshot()
            snapshot.reloadItems([id])
            onUpdate?()
        }.store(in: &cancellables)
    }
    
    func recreateSnapshot() {
        snapshot = NSDiffableDataSourceSnapshot<Int, UUID>()
        snapshot.appendSections([0])
        snapshot.appendItems(gridModel.flattenedPads.map { $0.id })

    }
    
}
