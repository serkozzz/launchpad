//
//  DBGenerator.swift
//  launchpad
//
//  Created by Sergey Kozlov on 09.03.2025.
//

import CoreData

class DBGenerator {
    func generateIfNeeded() {
        
        let fetchRequest: NSFetchRequest<LaunchpadPadDB> = LaunchpadPadDB.fetchRequest()
        let count = try? CoreDataStack.shared.managedContext.count(for: fetchRequest)

        guard let bandCount = count, bandCount == 0 else { return }
        
        generate()
    }
    
    private func generate() {
        let context = CoreDataStack.shared.managedContext
        (0..<GRID_MAX_COLUMNS * GRID_MAX_ROWS).forEach {
            let pad = LaunchpadPadDB(context: context)
            pad.isActive = false
            pad.order = Int16($0)
        }
        
        do {
            try context.save()
            print("Successfully generated LaunchpadPadDB items")
        } catch {
            print("Failed to save generated items: \(error)")
        }
        
    }
}
