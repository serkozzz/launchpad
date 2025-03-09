//
//  LaunchpadGridCellContentView.swift
//  launchpad
//
//  Created by Sergey Kozlov on 06.03.2025.
//

import UIKit

class LaunchpadGridCellContentView : UIView, UIContentView {
    
    var configuration: UIContentConfiguration {
        didSet {
            update()
        }
    }
    
    init(_ configuration: UIContentConfiguration) {
        self.configuration = configuration
        super.init(frame:.zero)
        update()
    }
    
    private func setupView() {
        instrumentLabel.isHidden = true
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update() {
        let pad = cfg.pad
        if (cfg.editMode) {
            backgroundColor = .systemGray3
            instrumentLabel.isHidden = false
            instrumentLabel.text = pad.number.description
        }
        else {
            backgroundColor = pad.isActive ? .cyan : .systemGray5
            instrumentLabel.isHidden = true
        }
    }
    
    private var cfg: LaunchpadGridCellContentConfiguration {
        configuration as! LaunchpadGridCellContentConfiguration
    }
    
    private lazy var instrumentLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
        return label
    }()
}
