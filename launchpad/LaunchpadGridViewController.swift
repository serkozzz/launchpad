//
//  ViewController.swift
//  launchpad
//
//  Created by Sergey Kozlov on 05.03.2025.
//

import UIKit
import Combine

class LaunchpadGridViewController: UIViewController, UICollectionViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var dataSource: UICollectionViewDiffableDataSource<Int, UUID>!
    
    var gridModel = LaunchpadModel.shared.grid
    private var cancellables: Set<AnyCancellable> = []
    private var padsAnimator = PadsAnimator()
    private var soundsPlayer = SoundsPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(LaunchpadGridCell.self, forCellWithReuseIdentifier: LaunchpadGridCell.reuseID)
        collectionView.collectionViewLayout = createLayout()
        collectionView.delegate = self 
        
        dataSource = UICollectionViewDiffableDataSource<Int, UUID>(collectionView: collectionView) { [weak self] collectionView, indexPath, itemIdentifier in
            guard let self else { return nil }
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LaunchpadGridCell.reuseID, for: indexPath) as! LaunchpadGridCell
            
            let pad = gridModel.pad(for: itemIdentifier)
            let cfg = LaunchpadGridCellContentConfiguration(pad: pad)
            cell.contentConfiguration = cfg
            
            return cell
        }
        applySnapshot()
        
        gridModel.columnsChanged.sink { [weak self] _ in
            guard let self else { return }
            applySnapshot()
        }.store(in: &cancellables)
        
        gridModel.rowsChanged.sink { [weak self] _ in
            guard let self else { return }
            applySnapshot()
        }.store(in: &cancellables)
        
        gridModel.padChanged.sink { [weak self] id in
            guard let self else { return }
            var snapshot = dataSource.snapshot()
            snapshot.reloadItems([id])
            dataSource.apply(snapshot, animatingDifferences: false)
        }.store(in: &cancellables)
    }

    func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, UUID>()
        snapshot.appendSections([0])
        snapshot.appendItems(gridModel.flattenedPads.map { $0.id })
        dataSource.apply(snapshot)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("tooglePad")
        let id = dataSource.itemIdentifier(for: indexPath)!
        padsAnimator.blink(padID: id)
        soundsPlayer.play(instrumentNumber: 0)
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

