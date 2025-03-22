//
//  ViewController.swift
//  launchpad
//
//  Created by Sergey Kozlov on 05.03.2025.
//

import UIKit
import Combine
import CoreData

class LaunchpadGridViewController: UIViewController, UICollectionViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var dataSource: UICollectionViewDiffableDataSource<Int, NSManagedObjectID>!
    
    var editMode: Bool = false {
        didSet {
            reloadAllItems()
        }
    }
    
    private var cancellables: Set<AnyCancellable> = []
    private var padsAnimator = PadsAnimator()
    private var soundsPlayer = SoundsPlayer()
    private var gridViewModel = LaunchpadGridViewModel()
    private var editingPad: NSManagedObjectID?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(LaunchpadGridCell.self, forCellWithReuseIdentifier: LaunchpadGridCell.reuseID)
        collectionView.collectionViewLayout = createLayout()
        collectionView.delegate = self
        collectionView.delaysContentTouches = false
        collectionView.isScrollEnabled = false
        
        dataSource = UICollectionViewDiffableDataSource<Int, NSManagedObjectID>(collectionView: collectionView) { [weak self] collectionView, indexPath, itemIdentifier in
            guard let self else { return nil }
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LaunchpadGridCell.reuseID, for: indexPath) as! LaunchpadGridCell
            
            let pad = gridViewModel.pad(for: itemIdentifier)
            cell.pad = pad
            cell.delegate = self
            let cfg = LaunchpadGridCellContentConfiguration(pad: pad, editMode: editMode)
            cell.contentConfiguration = cfg
            
            return cell
        }
        
        applySnapshot()
        gridViewModel.onUpdate = { [weak self] changeType in
            guard let self else { return }
            let animating = changeType == .collectionUpdated
            applySnapshot(animating: animating)
        }
    }

    func applySnapshot(animating: Bool = true) {
        dataSource.apply(gridViewModel.snapshot, animatingDifferences: animating)
    }
    
    func reloadAllItems() {
        var snapshot = gridViewModel.snapshot
        snapshot.reloadItems(snapshot.itemIdentifiers)
        dataSource.apply(snapshot, animatingDifferences: true)
    }

//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
//    }
}

extension LaunchpadGridViewController : LaunchpadGridCellDelegate {
    func launchpadGridCellDidTap(_ cell: LaunchpadGridCell) {
        
        print("tooglePad")
        let id = cell.pad.id
        let pad = gridViewModel.pad(for: id)
        
        if (editMode) {
            editingPad = id
            let vc = LibraryViewController.createFromStoryboard()
            vc.delegate = self
            present(vc, animated: true)
        }
        else {
            padsAnimator.blink(padID: id)
            if let instrumentID = pad.instrumentID {
                soundsPlayer.play(instumentID: instrumentID)
            }
        }
    }
}

extension LaunchpadGridViewController : LibraryViewControllerDelegate {
    func libraryViewController(_ controller: LibraryViewController, didSelectInstrument id: NSManagedObjectID) {
        dismiss(animated: true) { [self] in
            gridViewModel.setInstrument(id, for: editingPad!)
        }
    }
}


extension LaunchpadGridViewController {
    func createLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout () { [self] sectionIndex, environment in
            //guard let self = self else { return nil }
            
            let itemFractWidth = 1.0 / CGFloat(gridViewModel.columns)
            let groupFractHeight =  1.0 / CGFloat(gridViewModel.rows)
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(itemFractWidth), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(groupFractHeight))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            return section
        }
    }
}

