//
//  SoundsMap.swift
//  launchpad
//
//  Created by Sergey Kozlov on 08.03.2025.
//

class InstrumentsMap {
    
    var instruments: [InstrumentModel] = [
        InstrumentModel(name: "kick", imageName: "kick.jpg", audioFileName: "kick.wav"),
        InstrumentModel(name: "snare", imageName: "snare.jpg", audioFileName: "snare.wav"),
        InstrumentModel(name: "hat", imageName: "hat.jpg", audioFileName: "hat.wav"),
        InstrumentModel(name: "hat-opened", imageName: "hat-opened.jpg", audioFileName: "hat-opened.wav"),
        InstrumentModel(name: "crash", imageName: "crash.jpg", audioFileName: "crash.wav")]
    
    
    subscript(row: Int, column: Int) -> InstrumentModel? {
        get {
            if row > 2 || column > 2 {
                return nil
            }
            return instruments[0]
        }
    }
    
    
}
