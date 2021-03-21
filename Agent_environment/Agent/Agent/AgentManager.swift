//
//  AgentManager.swift
//  Agent
//
//  Created by Roman Mishchenko on 03.03.2021.
//

import Foundation

public class AgentManager {
    public var grid: [[Node]]
    public var gridRows: Int {
        get {
            return grid[0].count
        }
    }
    public var gridCols: Int {
        get {
            return grid.count
        }
    }
    init(grid: [[Node]]) {
        self.grid = grid
    }
    
    public func findPath(start: Vector2, end: Vector2) -> [Node]? {
        
        //MARK: ADD Path finding
        
        return []
    }
    
    public func getAdjacentNodes(n: Node) -> [Node] {
        var temp: [Node] = []
        let row = Int(n.position.y)
        let col = Int(n.position.x)
        
        if row + 1 < gridRows {
            temp.append(grid[col][row + 1])
        }
        if row - 1 >= 0 {
            temp.append(grid[col][row - 1])
        }
        if col - 1 >= 0 {
            temp.append(grid[col - 1][row])
        }
        if col + 1 < gridRows {
            temp.append(grid[col + 1][row])
        }
        temp.filter{$0.walkable}
        return temp
    }
    
    
}
