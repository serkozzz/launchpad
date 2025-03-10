//
//  ContentLoader.swift
//  drums-sequencer
//
//  Created by Sergey Kozlov on 18.02.2025.
//

import Foundation

class ContentManager {
    
    static let shared: ContentManager = ContentManager()
    let fileManager = FileManager.default
    let documentsDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    lazy var audioStorageURL: URL = documentsDir.appendingPathComponent(Globals.AUDIO_STORAGE_ROOT)
    
    func loadAudioStorageIfNeeded(dirURL url: URL) throws {
        
        let destinationDir = audioStorageURL
        guard !fileManager.fileExists(atPath: destinationDir.path) else { return }
        
        // Создаем новую папку tmp/FilesStorage
        try fileManager.createDirectory(at: destinationDir, withIntermediateDirectories: true, attributes: nil)
        
        // Проверяем, является ли исходный URL директорией
        var isDirectory: ObjCBool = false
        guard fileManager.fileExists(atPath: url.path, isDirectory: &isDirectory), isDirectory.boolValue else {
            throw NSError(domain: "loadFilesStorage", code: 1, userInfo: [NSLocalizedDescriptionKey: "Source URL is not a directory"])
        }
        
        // Копируем содержимое исходной папки в tmp/FilesStorage
        let contents = try fileManager.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: [])
        for item in contents {
            let destination = destinationDir.appendingPathComponent(item.lastPathComponent)
            print(item.lastPathComponent)
            try fileManager.copyItem(at: item, to: destination)
        }
    }
    
    func addAudioFile(url: URL) throws {
        let destination = audioStorageURL.appendingPathComponent(url.lastPathComponent)
        try fileManager.copyItem(at: url, to: destination)
    }
    
    func urlForAudio(_ fileName: String) -> URL {
        let result = documentsDir.appending(component: Globals.AUDIO_STORAGE_ROOT).appending(component: fileName)
        return result
    }
}
