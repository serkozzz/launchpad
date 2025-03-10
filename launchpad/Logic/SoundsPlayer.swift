//
//  SoundsPlayer.swift
//  drums-sequencer
//
//  Created by Sergey Kozlov on 18.02.2025.
//

import Foundation
import AVFAudio
import CoreData

class SoundsPlayer {
    
    private let engine = AVAudioEngine()
    private var samplers: [NSManagedObjectID: AudioSampler] = [:]
    
    init() {
        configureAudioSession()
        LaunchpadModel.shared.instrumentsLibrary.instruments.forEach {
            let wavURL = ContentManager.shared.urlForAudio($0.audioFileName)
            samplers[$0.id] = AudioSampler(engine: engine, wavUrl: wavURL)
        }
        startAudioEngine()
    }
    
    func play(instument: InstrumentDB) {
        samplers[instument.objectID]!.play()
    }
    

    
}

extension SoundsPlayer {
    private func startAudioEngine() {
        do {
            try engine.start()
        } catch {
            print("Ошибка запуска AVAudioEngine: \(error.localizedDescription)")
        }
    }
    
    private func configureAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Ошибка настройки аудиосессии: \(error.localizedDescription)")
        }
    }
}
