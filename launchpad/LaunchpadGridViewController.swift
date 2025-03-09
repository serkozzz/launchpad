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
    
    var gridModel = LaunchpadModel.shared.grid
    var editMode: Bool = false {
        didSet {
            reloadAllItems()
        }
    }
    
    private var cancellables: Set<AnyCancellable> = []
    private var padsAnimator = PadsAnimator()
    private var soundsPlayer = SoundsPlayer()
    private var launchpadViewModel = LaunchpadViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(LaunchpadGridCell.self, forCellWithReuseIdentifier: LaunchpadGridCell.reuseID)
        collectionView.collectionViewLayout = createLayout()
        collectionView.delegate = self 
        
        dataSource = UICollectionViewDiffableDataSource<Int, NSManagedObjectID>(collectionView: collectionView) { [weak self] collectionView, indexPath, itemIdentifier in
            guard let self else { return nil }
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LaunchpadGridCell.reuseID, for: indexPath) as! LaunchpadGridCell
            
            let pad = gridModel.pad(for: itemIdentifier)
            cell.pad = pad
            cell.delegate = self
            let cfg = LaunchpadGridCellContentConfiguration(pad: pad, editMode: editMode)
            cell.contentConfiguration = cfg
            
            return cell
        }
        applySnapshot()
        launchpadViewModel.onUpdate = { [weak self] changeType in
            guard let self else { return }
            let animating = changeType == .collectionUpdated
            applySnapshot(animating: animating)
        }
    }

    func applySnapshot(animating: Bool = true) {
        dataSource.apply(launchpadViewModel.snapshot, animatingDifferences: animating)
    }
    
    func reloadAllItems() {
        var snapshot = launchpadViewModel.snapshot
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
        let pad = gridModel.pad(for: id)
        
        if (editMode) {
            
        }
        else {
            padsAnimator.blink(padID: id)
            if let instrument = pad.instrument {
                soundsPlayer.play(instument: instrument)
            }
        }
    }
    
    
}

extension LaunchpadGridViewController {
    func createLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout () { [self] sectionIndex, environment in
            //guard let self = self else { return nil }
            
            let itemFractWidth = 1.0 / CGFloat(gridModel.columns)
            let groupFractHeight =  1.0 / CGFloat(gridModel.rows)
            
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

