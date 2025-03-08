//
//  AudioPlayer.swift
//  easy-peasy
//
//  Created by Sergey Kozlov on 10.01.2025.
//
import AVFoundation

class AudioSampler {
    
    private let playerNode = AVAudioPlayerNode()
    private var audioFile: AVAudioFile?

    init(engine: AVAudioEngine, wavUrl: URL) {
        engine.attach(playerNode)
        engine.connect(playerNode, to: engine.mainMixerNode, format: nil)
        loadSound(url: wavUrl)
       // loadSound(
    }
    
    var audioBuffer: AVAudioPCMBuffer?

    func loadSound(url: URL) {
        do {
            let audioFile = try AVAudioFile(forReading: url)
            let format = audioFile.processingFormat
            let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: AVAudioFrameCount(audioFile.length))!
            try audioFile.read(into: buffer)
            audioBuffer = buffer
        } catch {
            print("Ошибка загрузки файла: \(error.localizedDescription)")
        }
    }

    func play() {
        guard let buffer = audioBuffer else { return }
        playerNode.stop()
        playerNode.scheduleBuffer(buffer, at: nil, options: [], completionHandler: nil)
        playerNode.play()
    }
}
