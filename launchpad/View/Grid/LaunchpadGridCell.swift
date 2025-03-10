//
//  LaunchpadCell.swift
//  launchpad
//
//  Created by Sergey Kozlov on 05.03.2025.
//

import UIKit

protocol LaunchpadGridCellDelegate: AnyObject {
    func launchpadGridCellDidTap(_ cell: LaunchpadGridCell)
}

class LaunchpadGridCell: UICollectionViewCell {
    static let reuseID = "LaunchpadGridCell"
    weak var delegate: LaunchpadGridCellDelegate?
    
    var pad: LaunchpadPad!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isMultipleTouchEnabled = true // Включаем multi-touch для ячейки
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.launchpadGridCellDidTap(self)
    }
        
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        backgroundColor = .gray // Возвращаем цвет при отпускании
//    }
//
//    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
//        backgroundColor = .gray // Обработка отмены касания
//    }
}

