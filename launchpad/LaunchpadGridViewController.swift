//
//  ViewController.swift
//  launchpad
//
//  Created by Sergey Kozlov on 05.03.2025.
//

import UIKit

class LaunchpadGridViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var dataSource: UICollectionViewDiffableDataSource<Int, UUID>!
    
    var gridModel = LaunchpadModel.shared.grid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(LaunchpadGridCell.self, forCellWithReuseIdentifier: LaunchpadGridCell.reuseID)
        collectionView.collectionViewLayout = createLayout()
        
        dataSource = UICollectionViewDiffableDataSource<Int, UUID>(collectionView: collectionView) { [weak self] collectionView, indexPath, itemIdentifier in
            guard let self else { return nil }
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LaunchpadGridCell.reuseID, for: indexPath) as! LaunchpadGridCell
            
            let pad = gridModel.pad(for: itemIdentifier)
            let color: UIColor = pad.isActive ? .cyan : .systemGray5
            
            cell.configure(LaunchpadGridCell.Configuration(color: color))
            return cell
        }
        applySnapshot()
    }

    func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, UUID>()
        snapshot.appendSections([0])
        snapshot.appendItems(gridModel.flattenedPads.map { $0.id })
        dataSource.apply(snapshot)
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

