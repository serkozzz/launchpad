//
//  ContentLoader.swift
//  drums-sequencer
//
//  Created by Sergey Kozlov on 18.02.2025.
//

import Foundation

class ContentLoader {
    
    static let shared: ContentLoader = ContentLoader()
    let fileManager = FileManager.default
    
    
    func loadAudioStorage(dirURL url: URL) throws {
        
        let tempDir = fileManager.temporaryDirectory
        let destinationDir = tempDir.appendingPathComponent(Globals.AUDIO_STORAGE_ROOT)
        
        // Удаляем папку tmp/FilesStorage, если она существует
        if fileManager.fileExists(atPath: destinationDir.path) { try fileManager.removeItem(at: destinationDir) }
        
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
}
