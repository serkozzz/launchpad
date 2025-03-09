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

    
    
    private var allPads = [LaunchpadPad]()
    
    var visiblePads: [LaunchpadPad] {
        get {
            var result = [LaunchpadPad]()
            for i in 0..<rows {
                var start = i * GRID_MAX_COLUMNS
                result += allPads[start..<(start + columns)]
            }
            return result
        }
    }
    
    private(set) subscript(row: Int, column: Int) -> LaunchpadPad {
        get {
            let index = row * GRID_MAX_COLUMNS + column
            return allPads[index]
        }
        set {
            let index = row * GRID_MAX_COLUMNS + column
            allPads[index] = newValue
        }
    }
    
    init () {
        allPads = (0..<GRID_MAX_ROWS * GRID_MAX_COLUMNS).map { _ in LaunchpadPad()  }
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
    
    func togglePad(_ id: UUID) {
        let index = allPadsIndex(for: id)
        allPads[index].isActive.toggle()
        padChanged.send(id)
    }
    
    func pad(for id: UUID) -> LaunchpadPad {
        return allPads.first(where: { $0.id == id})!
    }
    
    private func allPadsIndex(for id: UUID) -> Int {
        return allPads.firstIndex(where: {$0.id == id})!
    }
    
    private func padCoords(for id: UUID) -> (Int, Int) {
        for i in 0..<rows {
            for j in 0..<columns {
                if self[i, j].id == id {
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


