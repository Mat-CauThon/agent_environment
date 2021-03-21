//
//  MapManager.swift
//  Agent
//
//  Created by Roman Mishchenko on 03.03.2021.
//

import Foundation

enum MapType {
    case roomWithBlocks
}

struct MapItem {
    var value: String
    var position: Vector2
}

class MapManager {
    
    var map: [[MapItem]] = []
    let mapSize = AppConstants.mapSize
    let numberOfBlocks = Int.random(in: 20...80)
    let numberOfGarbadge: Int
    var agentManager: AgentManager!
    var isSearchingPath = false
    var energyConsumed: Int = 0
    
    var agentPosition: Vector2 {
        get {
            return self.map.flatMap{$0}.first{$0.value == AppConstants.agent}?.position ?? Vector2(x: 0, y: 0)
        }
    }
    
    var isHavePath: Bool {
        return !self.agentPath.isEmpty
    }
    
    var isHaveGarbadge: Bool {
        get {
            for item in self.map {
                for sub in item {
                    if sub.value == AppConstants.garbage {
                        return true
                    }
                }
            }
            return false
        }
    }
    
    var garbadgeCount: Int {
        get {
            var count = 0
            for i in 0..<self.map.count {
                for j in 0..<self.map[i].count {
                    if map[i][j].value == AppConstants.garbage {
                        count += 1
                    }
                }
            }
            return count
        }
    }
    
    var persentOfClean: String {
        get {
            let size = (AppConstants.mapSize-1) * (AppConstants.mapSize-1)
            let garbadgePersent = Float(self.garbadgeCount * 100) / Float(size - self.numberOfBlocks)
            return String(format: "%.2f", 100 - garbadgePersent)
        }
    }
    
    var agentPath: [Vector2] = []
    
    init(mapType: MapType, garbadgeLimit: Int) {
        self.numberOfGarbadge = garbadgeLimit
        self.map = self.createMap(type: mapType)
        let grid = self.getGrid(from: self.map)
        self.agentManager = AgentManager(grid: grid)
        let stringMap = self.map.map { (array) -> [String] in
            array.map { (item) -> String in
                item.value
            }
        }
        print(stringMap)
        let path = agentManager.findPath(start: self.agentPosition, end: self.findNextGarbadgeToGo())?.map{$0.position}
        self.set(path: path ?? [])
    }
    
    func findNewPath() {
        self.isSearchingPath = true
        let path = agentManager.findPath(start: self.agentPosition, end: self.findNextGarbadgeToGo())?.map{$0.position}
        if path?.count == 1 && path?.first == self.agentPosition {
            self.set(path: [])
        } else {
            self.set(path: path ?? [])
        }
        
        self.isSearchingPath = false
    }
    
    func getGrid(from map: [[MapItem]]) -> [[Node]] {
        return map.map { (array) -> [Node] in
            array.map { (item) -> Node in
                return Node(pos: item.position, walkable: item.value != AppConstants.wall)
            }
        }
    }
    
    public func createMap(type: MapType) -> [[MapItem]] {
        switch type {
            case .roomWithBlocks:
                return self.createRoomWithBlocks()
        }
    }
        
    public func createRoomWithBlocks() -> [[MapItem]] {
        
        var newMap = Array(repeating: Array(repeating: MapItem(value: "", position: Vector2(x: 0, y: 0)), count: self.mapSize), count: self.mapSize)
        
        for i in 0..<self.mapSize {
            for j in 0..<self.mapSize {
                newMap[i][j] = MapItem(value: AppConstants.mapVoid, position: Vector2(x: Float(i), y: Float(j)))
            }
        }
        
        
        
        for i in 0..<self.mapSize {
            newMap[i][0].value = AppConstants.wall
            newMap[0][i].value = AppConstants.wall
            newMap[i][self.mapSize-1].value = AppConstants.wall
            newMap[self.mapSize-1][i].value = AppConstants.wall
        }
        
        for _ in 0..<self.numberOfBlocks {
            let i = Int.random(in: 2..<self.mapSize-2)
            let j = Int.random(in: 2..<self.mapSize-2)
            if newMap[i-1][j-1].value != AppConstants.wall && newMap[i+1][j+1].value != AppConstants.wall && newMap[i+1][j-1].value != AppConstants.wall && newMap[i-1][j+1].value != AppConstants.wall {
                newMap[i][j].value = AppConstants.wall
            }
        }
        
        var isSeted = false
        while !isSeted {
            let i = Int.random(in: 1..<self.mapSize-1)
            let j = Int.random(in: 1..<self.mapSize-1)
            if newMap[i][j].value != AppConstants.wall && newMap[i][j].value != AppConstants.garbage {
                newMap[i][j].value = AppConstants.agent
                isSeted = true
            }
        }
        
        var k = 0
        
        while k < self.numberOfGarbadge && self.isFilled(map: newMap) {
            let i = Int.random(in: 1..<self.mapSize-1)
            let j = Int.random(in: 1..<self.mapSize-1)
            if newMap[i][j].value != AppConstants.wall && newMap[i][j].value != AppConstants.agent && newMap[i][j].value != AppConstants.garbage {
                newMap[i][j].value = AppConstants.garbage
                k += 1
            }
        }
        
        return newMap
    }
    
    func isFilled(map: [[MapItem]]) -> Bool {
        for item in map {
            for sub in item {
                if sub.value == AppConstants.mapVoid {
                    return true
                }
            }
        }
        return false
    }
    
    func moveRandom() {
        guard self.isHaveGarbadge == true else {
            return
        }
        let direction = Int.random(in: 1...4)
        
        var x = 0
        var y = 0
        
        switch direction {
            case 1:
                x = Int(self.agentPosition.x + 1)
                y = Int(self.agentPosition.y)
                if self.map[x][y].value == AppConstants.wall { return }
            case 2:
                x = Int(self.agentPosition.x)
                y = Int(self.agentPosition.y + 1)
                if self.map[x][y].value == AppConstants.wall { return }
            case 3:
                x = Int(self.agentPosition.x - 1)
                y = Int(self.agentPosition.y)
                if self.map[x][y].value == AppConstants.wall { return }
            case 4:
                x = Int(self.agentPosition.x)
                y = Int(self.agentPosition.y - 1)
                if self.map[x][y].value == AppConstants.wall { return }
            default: ()
        }
        
        if self.persentOfClean != "100.00%" {
            self.energyConsumed += 1
        }
        
        for i in 0..<self.map.count {
            for j in 0..<self.map[i].count {
                if self.map[i][j].value == AppConstants.agent {
                    self.map[i][j].value = AppConstants.mapVoid
                }
            }
        }
        self.map[x][y].value = AppConstants.agent
    }
    
    func moveAgent() {
        
        if !self.agentPath.isEmpty {
            self.energyConsumed += 1
        }
        
        let first = self.agentPath.removeFirst()
        let x = Int(first.x)
        let y = Int(first.y)
        
        if self.map[x][y].value == AppConstants.garbage {
            self.energyConsumed += 1
        }
        
        for i in 0..<self.map.count {
            for j in 0..<self.map[i].count {
                if self.map[i][j].value == AppConstants.agent {
                    self.map[i][j].value = AppConstants.mapVoid
                }
            }
        }
        self.map[x][y].value = AppConstants.agent
    }
    
    func findNextGarbadgeToGo() -> Vector2 {
        
        //MARK: ADD Selecting of the next Garbadge Position
        
        return Vector2()
    }
    
    func checkPoint(point: String) -> Bool {
        return point == AppConstants.garbage
    }
    
    func set(path: [Vector2]) {
        self.agentPath = path
    }
    
}
