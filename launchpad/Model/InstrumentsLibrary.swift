//
//  InstrumentsLibrary.swift
//  launchpad
//
//  Created by Sergey Kozlov on 10.03.2025.
//

import UIKit
import CoreData
import Combine

class InstrumentsLibrary : NSObject {
    
    override init() {
        super.init()
        do { try fetchedResultsController.performFetch() }
        catch let error as NSError {
            print("Fetching error: \(error), \(error.userInfo)")
        }
    }
    
    var instruments: [Instrument] {
        fetchedResultsController.fetchedObjects!.map { Instrument($0)}
    }

    func instrument(for id: NSManagedObjectID) -> Instrument {
        Instrument(fetchedResultsController.fetchedObjects!.first(where: {id == $0.objectID})!)
    }
    
    func addInstrument(name: String, imageFileName: String?, audioFileName: String){
        let context = CoreDataStack.shared.managedContext

        let instrumentDB = InstrumentDB(context: context)
        instrumentDB.name = name
        instrumentDB.imageName = imageFileName
        instrumentDB.audioFileName = audioFileName

        CoreDataStack.shared.saveContext()
    }
    
    private lazy var fetchedResultsController: NSFetchedResultsController<InstrumentDB> = {
        
        let fetchRequest: NSFetchRequest<InstrumentDB> = InstrumentDB.fetchRequest()
        
        //обязательно нужна какая то сортировка иначе креш
        let nameSort = NSSortDescriptor(key: #keyPath(InstrumentDB.name), ascending: true)
        fetchRequest.sortDescriptors = [nameSort]
    
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: CoreDataStack.shared.managedContext,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: "InstrumentsLibrary")
        
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    
    
    private func fetchInstruments() -> [InstrumentDB] {
        let fetchRequest: NSFetchRequest<InstrumentDB> = InstrumentDB.fetchRequest()
        let instruments = try! CoreDataStack.shared.managedContext.fetch(fetchRequest)
        return instruments
    }
    
    
    let collectionChanged = PassthroughSubject<NSDiffableDataSourceSnapshot<String, NSManagedObjectID>, Never>()
}

extension InstrumentsLibrary: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<any NSFetchRequestResult>, didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference) {
        var snapshot = snapshot as NSDiffableDataSourceSnapshot<String, NSManagedObjectID>
        collectionChanged.send(snapshot)
    }
    
}
