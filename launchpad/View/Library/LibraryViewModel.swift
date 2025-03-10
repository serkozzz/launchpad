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
    var onUpdate: (() -> Void)?
    
    private(set) var snapshot: NSDiffableDataSourceSnapshot<Int, NSManagedObjectID>!
    private var instruments = LaunchpadModel.shared.instrumetns
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        recreateSnapshot()
    }
    
    func recreateSnapshot() {
        snapshot = NSDiffableDataSourceSnapshot<Int, NSManagedObjectID>()
        snapshot.appendSections([0])
        snapshot.appendItems(instruments.map { $0.id })
    }
    
    
    func addInstrument(name: String, audioFileName: String) {
        let context = CoreDataStack.shared.managedContext

        
        let instrument = InstrumentDB(context: context)
        instrument.name = name
        //instrument.imageName = imageName
        instrument.audioFileName = audioFileName

        do {
            try context.save()
            //instruments.append(newInstrument) // Обновляем локальный массив
            //recreateSnapshot() // Обновляем снапшот
            //onUpdate?() // Оповещаем UI
        } catch {
            print("Failed to save instrument: \(error)")
        }
    }
}
