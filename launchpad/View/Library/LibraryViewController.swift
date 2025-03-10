//
//  LibraryViewController.swift
//  launchpad
//
//  Created by Sergey Kozlov on 09.03.2025.
//

import UIKit
import CoreData
import UniformTypeIdentifiers


class LibraryViewController: UIViewController {
    
    private var reuseID = "LibraryViewControllerCell"
    
    @IBOutlet weak var tableView: UITableView!
    
    private var viewModel = LibraryViewModel()
    private var dataSource: UITableViewDiffableDataSource<Int, NSManagedObjectID>!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseID)
        
        dataSource = UITableViewDiffableDataSource<Int, NSManagedObjectID>(tableView: tableView) { tableView, indexPath, objectID in
            
            let cell = tableView.dequeueReusableCell(withIdentifier: self.reuseID, for: indexPath)
            var cfg = UIListContentConfiguration.cell()
            cfg.text = LaunchpadModel.shared.instrument(for: objectID).name
            cell.contentConfiguration = cfg
            return cell
        }
        viewModel.onUpdate = { [weak self] in self?.applySnapshot() }
        applySnapshot()
    }
    
    func applySnapshot(animating: Bool = true) {
        dataSource.apply(viewModel.snapshot, animatingDifferences: animating)
    }
    
    
    @IBAction func uploadNew(_ sender: Any) {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.wav])
     
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        present(documentPicker, animated: true, completion: nil)
    }
}


extension LibraryViewController: UIDocumentPickerDelegate {
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let url = urls.first else { return }
        
        // Обработка выбранного файла
        print("Picked file: \(url)")
        
        if url.startAccessingSecurityScopedResource() {
            try! ContentManager.shared.addAudioFile(url: url)
            viewModel.addInstrument(name: url.deletingPathExtension().lastPathComponent, audioFileName: url.lastPathComponent)
            
            url.stopAccessingSecurityScopedResource()
        }
    
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("User cancelled document picker")
    }
}

