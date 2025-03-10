//
//  LibraryViewModel.swift
//  launchpad
//
//  Created by Sergey Kozlov on 09.03.2025.
//
import CoreData
import UIKit
import Combine


class LibraryViewModel {
    typealias LibrarySnapshot = NSDiffableDataSourceSnapshot<String, NSManagedObjectID>
    
    var collectionChanged: (() -> Void)?
    private(set) var snapshot: LibrarySnapshot!
    
    private var instrumentslibrary = LaunchpadModel.shared.instrumentsLibrary
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        instrumentslibrary.collectionChanged.sink { [weak self] snapshot in
            guard let self = self else { return }
            self.snapshot = snapshot
            collectionChanged?()
        }.store(in: &cancellables)
        //you need create first snapshot manually, casuse fetchedResultsController doesn't call its delegate on start
        updateSnapshot()
    }
    
    func addInstrument(name: String, imageFileName: String?, audioFileName: String) {
        instrumentslibrary.addInstrument(name: name, imageFileName: imageFileName, audioFileName: audioFileName)
    }
    
    func instrument(for id: NSManagedObjectID) -> Instrument {
        instrumentslibrary.instrument(for: id)
    }
    
    private func updateSnapshot() {
        var newSnapshot = LibrarySnapshot()
        newSnapshot.appendSections([""])
        newSnapshot.appendItems(instrumentslibrary.instruments.map { $0.id })
        snapshot = newSnapshot
        collectionChanged?()
    }
}

