//
//  LaunchpadGridModel.swift
//  launchpad
//
//  Created by Sergey Kozlov on 05.03.2025.
//

import Foundation
import Combine

let GRID_MAX_COLUMNS = 5
let GRID_MIN_COLUMNS = 2
let GRID_MAX_ROWS = 5
let GRID_MIN_ROWS = 2
let GRID_DEFAULT_COLUMNS = 3
let GRID_DEFAULT_RAWS = 3

struct LaunchpadPad {
    var isActive: Bool = false
    var id = UUID()
}

class LaunchpadGridModel {
    
    private(set) var columns = GRID_DEFAULT_COLUMNS {
        didSet { columnsChanged.send(columns) }
    }
    private(set) var rows = GRID_DEFAULT_RAWS {
        didSet { rowsChanged.send(rows) }
    }

    private(set) var pads = [[LaunchpadPad]]()
    var flattenedPads: [LaunchpadPad] {
        let allRows = pads.flatMap { Array($0.prefix(columns)) }
        return Array(allRows.prefix(rows * columns))
    }
    
    init () {
        pads = (0..<GRID_MAX_ROWS).map { _ in
            (0..<GRID_MAX_COLUMNS).map { _ in
                LaunchpadPad()
            }
        }
    }
    
    func increaseGrid() {
        guard columns + 1 <= GRID_MAX_COLUMNS, rows + 1 <= GRID_MAX_ROWS else { return }
        columns += 1
        rows += 1
    }
    
    func decreaseGrid() {
        guard columns - 1 >= GRID_MIN_COLUMNS, rows - 1 >= GRID_MIN_ROWS else { return }
        columns -= 1
        rows -= 1
    }
    
    func togglePad(_ id:UUID) {
        let (i,j) = padCoords(for: id)
        pads[i][j].isActive.toggle()
        padChanged.send(pads[i][j].id)
    }
    
    func pad(for id: UUID) -> LaunchpadPad {
        return flattenedPads.first(where: { $0.id == id})!
    }
    
    private func padCoords(for id: UUID) -> (Int, Int) {
        for i in 0..<rows {
            for j in 0..<columns {
                if pads[i][j].id == id {
                    return (i, j)
                }
            }
        }
        fatalError("padCoords: id is not on the grid")
    }

    
    var columnsChanged = PassthroughSubject<Int, Never>()
    var rowsChanged = PassthroughSubject<Int, Never>()
    var padChanged = PassthroughSubject<UUID, Never>()
}


