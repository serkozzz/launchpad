//
//  LibraryViewModel.swift
//  launchpad
//
//  Created by Sergey Kozlov on 09.03.2025.
//
import CoreData
import UIKit
import Combine


class LibraryViewModel : NSObject {
    var onUpdate: (() -> Void)?
    
    private(set) var snapshot: NSDiffableDataSourceSnapshot<String, NSManagedObjectID>!
    private var cancellables: Set<AnyCancellable> = []
    
    override init() {
        super.init()
        do {
            try fetchedResultsController.performFetch()
        } catch let error as NSError {
            print("Fetching error: \(error), \(error.userInfo)")
        }
    }
        
    func addInstrument(name: String, audioFileName: String) {
        let context = CoreDataStack.shared.managedContext

        
        let instrument = InstrumentDB(context: context)
        instrument.name = name
        //instrument.imageName = imageName
        instrument.audioFileName = audioFileName

        do {
            try context.save()
        } catch {
            print("Failed to save instrument: \(error)")
        }
    }
    
    func instruments() -> [Instrument] {
        fetchedResultsController.fetchedObjects!.map { Instrument($0)}
    }
    
    func instrument(for id: NSManagedObjectID) -> Instrument {
        Instrument(fetchedResultsController.fetchedObjects!.first(where: {id == $0.objectID})!)
    }
    
    lazy var fetchedResultsController: NSFetchedResultsController<InstrumentDB> = {
        
        let fetchRequest: NSFetchRequest<InstrumentDB> = InstrumentDB.fetchRequest()
        
        //обязательно нужна какая то сортировка иначе креш
        let nameSort = NSSortDescriptor(key: #keyPath(InstrumentDB.name), ascending: true)
        fetchRequest.sortDescriptors = [nameSort]
    
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: CoreDataStack.shared.managedContext,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: "worldCup")
        
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
}


extension LibraryViewModel : NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<any NSFetchRequestResult>, didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference) {
        self.snapshot = snapshot as NSDiffableDataSourceSnapshot<String, NSManagedObjectID>
        onUpdate?()
    }
    
}
