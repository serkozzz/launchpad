//
//  SoundsPlayer.swift
//  drums-sequencer
//
//  Created by Sergey Kozlov on 18.02.2025.
//

import Foundation
import AVFAudio
import CoreData
import Combine

class SoundsPlayer {
    
    private let engine = AVAudioEngine()
    private var samplers: [NSManagedObjectID: AudioSampler] = [:]
    private var cancellables: Set<AnyCancellable> = []
    
    private var grid = LaunchpadModel.shared.grid
    
    init() {
        configureAudioSession()
        grid.visiblePads.forEach {
            guard let id = $0.instrumentID else { return }
            loadInstrumentIfNeed(id)
        }
        LaunchpadModel.shared.grid.padInstrumentChanged.sink { [weak self] padID in
            guard let self, let instrumentID = grid.pad(for: padID).instrumentID else { return }
            loadInstrumentIfNeed(instrumentID)
        }.store(in: &cancellables)
        
        startAudioEngine()
    }
    
    private func loadInstrumentIfNeed(_ id: NSManagedObjectID) {
        guard samplers[id] == nil else { return }
        let library = LaunchpadModel.shared.instrumentsLibrary
        let instrument = library.instrument(for: id)
        let wavURL = ContentManager.shared.urlForAudio(instrument.audioFileName)
        samplers[instrument.id] = AudioSampler(engine: engine, wavUrl: wavURL)
    }
    
    func play(instumentID: NSManagedObjectID) {
        samplers[instumentID]!.play()
    }
    
    deinit{
        cancellables.removeAll()
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
