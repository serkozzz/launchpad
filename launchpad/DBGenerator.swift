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
        
        guard let padsCount = count, padsCount == 0 else { return }
        
        generate()
    }
    
    private func generate() {
        let context = CoreDataStack.shared.managedContext
        
        
        let kick = createInstrument(name: "kick", imageName: "kick.jpg", audioFileName: "kick.wav")
        let snare = createInstrument(name: "snare", imageName: "snare.jpg", audioFileName: "snare.wav")
        let hat = createInstrument(name: "hat", imageName: "hat.jpg", audioFileName: "hat.wav")
        let hatOpened = createInstrument(name: "hat-opened", imageName: "hat-opened.jpg", audioFileName: "hat-opened.wav")
        let crash = createInstrument(name: "crash", imageName: "crash.jpg", audioFileName: "crash.wav")
        
        var pads = [LaunchpadPadDB]()
        (0..<GRID_MAX_COLUMNS * GRID_MAX_ROWS).forEach {
            let pad = LaunchpadPadDB(context: context)
            pad.isActive = false
            pad.order = Int16($0)
            pads.append(pad)
        }
        pads.first(where: { $0.order == 0})!.relationship = hatOpened
        pads.first(where: { $0.order == 1})!.relationship = snare
        pads.first(where: { $0.order == GRID_MAX_COLUMNS})!.relationship = hat
        pads.first(where: { $0.order == GRID_MAX_COLUMNS + 1})!.relationship = kick

        do {
            try context.save()
            print("Successfully generated LaunchpadPadDB items")
        } catch {
            print("Failed to save generated items: \(error)")
        }
    }
    
    private func createInstrument(name: String, imageName: String, audioFileName: String) -> InstrumentDB {
        let context = CoreDataStack.shared.managedContext
        let instrument = InstrumentDB(context: context)
        instrument.name = name
        instrument.imageName = imageName
        instrument.audioFileName = audioFileName
        return instrument
    }
}
