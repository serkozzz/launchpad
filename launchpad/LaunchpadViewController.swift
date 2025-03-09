//
//  LaunchpadViewController.swift
//  launchpad
//
//  Created by Sergey Kozlov on 05.03.2025.
//

import UIKit

class LaunchpadViewController: UIViewController {
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    private var gridVC: LaunchpadGridViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareAudioStorage()
        gridVC = children.first(where: {$0 is LaunchpadGridViewController}) as? LaunchpadGridViewController
        
    }
    @IBAction func minus(_ sender: Any) {
        LaunchpadModel.shared.grid.decreaseGrid()
    }
    @IBAction func plus(_ sender: Any) {
        LaunchpadModel.shared.grid.increaseGrid()
    }
    
    @IBAction func edit(_ sender: Any) {
        gridVC.editMode = true
        editButton.isHidden = true
        cancelButton.isHidden = false
    }
    
    @IBAction func cancel(_ sender: Any) {
        gridVC.editMode = false
        cancelButton.isHidden = true
        editButton.isHidden = false
    }
    
    private func prepareAudioStorage() {
        do {
            let url = Bundle.main.url(forResource: Globals.AUDIO_STORAGE_ROOT, withExtension: nil)!
            try ContentLoader.shared.loadAudioStorage(dirURL: url)
        }
        catch { print("ContentLoader.\(#function) Ошибка загрузки audioStorage: \(error)") }
    }
    
}
