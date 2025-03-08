//
//  LaunchpadViewController.swift
//  launchpad
//
//  Created by Sergey Kozlov on 05.03.2025.
//

import UIKit

class LaunchpadViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareAudioStorage()
        
    }
    @IBAction func minus(_ sender: Any) {
        LaunchpadModel.shared.grid.decreaseGrid()
    }
    @IBAction func plus(_ sender: Any) {
        LaunchpadModel.shared.grid.increaseGrid()
    }
    
    private func prepareAudioStorage() {
        do {
            let url = Bundle.main.url(forResource: Globals.AUDIO_STORAGE_ROOT, withExtension: nil)!
            try ContentLoader.shared.loadAudioStorage(dirURL: url)
        }
        catch { print("ContentLoader.\(#function) Ошибка загрузки audioStorage: \(error)") }
    }
    
}
