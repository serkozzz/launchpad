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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update() {
        let pad = cfg.pad
        if (cfg.editMode) {
            backgroundColor = .systemGray3
        }
        else {
            backgroundColor = pad.isActive ? .cyan : .systemGray5
        }
    }
    
    private var cfg: LaunchpadGridCellContentConfiguration {
        configuration as! LaunchpadGridCellContentConfiguration
    }
}
