//
//  LibraryViewController.swift
//  launchpad
//
//  Created by Sergey Kozlov on 09.03.2025.
//

import UIKit
import CoreData
import UniformTypeIdentifiers

protocol LibraryViewControllerDelegate: AnyObject {
    func libraryViewController(_ controller: LibraryViewController, didSelectInstrument id: NSManagedObjectID)
}

class LibraryViewController: UIViewController {
    
    @IBOutlet weak var plusButton: UIButton!
    
    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    weak var delegate: LibraryViewControllerDelegate?
    
    static func createFromStoryboard() -> LibraryViewController {
        let storyboard = UIStoryboard(name: "Library", bundle: nil)
        let vc = storyboard.instantiateInitialViewController { coder in LibraryViewController(coder: coder) }!
        return vc
    }
    
    private var reuseID = "LibraryViewControllerCell"
    @IBOutlet weak var tableView: UITableView!
    private var viewModel = LibraryViewModel()
    private var dataSource: LibraryTableViewDiffableDataSource!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseID)
        tableView.delegate = self

        dataSource = LibraryTableViewDiffableDataSource(tableView: tableView) { [weak self] tableView, indexPath, objectID in
            guard let self else { return nil }
            let cell = tableView.dequeueReusableCell(withIdentifier: self.reuseID, for: indexPath)
            var cfg = UIListContentConfiguration.cell()
            cfg.text = self.viewModel.instrument(for: objectID).name
            print(objectID)
            cell.contentConfiguration = cfg
            return cell
        }
        dataSource.viewModel = viewModel
        viewModel.collectionChanged = { [weak self] in self?.applySnapshot() }
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
    
    @IBAction func edit(_ sender: Any) {
        editButton.isHidden = true
        plusButton.isHidden = true
        cancelButton.isHidden = false
        tableView.isEditing  = true
    }
    
    @IBAction func cancel(_ sender: Any) {
        editButton.isHidden = false
        plusButton.isHidden = false
        cancelButton.isHidden = true
        tableView.isEditing  = false
        
    }
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true)
    }
    
}

extension LibraryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let id = dataSource.itemIdentifier(for: indexPath)!
        delegate?.libraryViewController(self, didSelectInstrument: id)
    }
}
    
extension LibraryViewController: UIDocumentPickerDelegate {
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let url = urls.first else { return }
        
        // Обработка выбранного файла
        print("Picked file: \(url)")
        
        if url.startAccessingSecurityScopedResource() {
            try! ContentManager.shared.addAudioFile(url: url)
            viewModel.addInstrument(name: url.deletingPathExtension().lastPathComponent, imageFileName: nil, audioFileName: url.lastPathComponent)
            url.stopAccessingSecurityScopedResource()
        }
    
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("User cancelled document picker")
    }
}






class LibraryTableViewDiffableDataSource: UITableViewDiffableDataSource<String, NSManagedObjectID> {
   
    weak var viewModel: LibraryViewModel?
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        let id = self.itemIdentifier(for: indexPath)!
        viewModel?.removeInstrument(with: id)
    }
}
