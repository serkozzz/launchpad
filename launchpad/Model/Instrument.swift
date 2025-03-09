
//
//  Instrumenet.swift
//  launchpad
//
//  Created by Sergey Kozlov on 09.03.2025.
//

import CoreData

struct Instrument {
    var name: String
    var imageName: String
    var audioFileName: String
    var id: NSManagedObjectID
    
    init(_ instrumentDB: InstrumentDB) {
        name = instrumentDB.name!
        imageName = instrumentDB.imageName!
        audioFileName = instrumentDB.audioFileName!
        id = instrumentDB.objectID
    }
}
