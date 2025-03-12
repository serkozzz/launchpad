//
//  CoreDataUtils.swift
//  launchpad
//
//  Created by Sergey Kozlov on 12.03.2025.
//

import CoreData

extension String {
    func toManagedObjectID(context: NSManagedObjectContext) -> NSManagedObjectID? {
        guard let url = URL(string: self),
              let objectID = context.persistentStoreCoordinator?.managedObjectID(forURIRepresentation: url) else {
            return nil
        }
        return objectID
    }
}

extension NSManagedObjectID {
    func toString() -> String {
        return uriRepresentation().absoluteString
    }
}
