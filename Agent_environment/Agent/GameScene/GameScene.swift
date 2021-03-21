//
//  GameScene.swift
//  Agent
//
//  Created by Roman Mishchenko on 03.03.2021.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
   
    var mapManager: MapManager?
    let scale = Int(AppConstants.mapScale)
    
    let limitField = NSTextField()
    let timeField = NSTextField()
    let timeLabel = NSTextField()
    let collectedLabel = NSTextField()
    let energyLabel = NSTextField()
    
    var limit: String = ""
    var maxTime: String = ""
    
    var secondLimit: Float = 35
    var secondCounter: Float = 0
    var garbagdeNumber = 0
    var garbadgeCounter = 0
    
    func prepare(controller: ViewController) {
        self.timeField.frame = NSRect(x: 0, y: 30, width: 200, height: 30)
        self.timeField.backgroundColor = .white
        self.timeField.textColor = .black
        self.timeField.placeholderString = "Time limit"
        self.timeField.delegate = controller
        self.timeField.tag = 2
        controller.view.addSubview(self.timeField)
        
        self.limitField.frame = NSRect(x: 0, y: 60, width: 200, height: 30)
        self.limitField.backgroundColor = .white
        self.limitField.textColor = .black
        self.limitField.placeholderString = "Garbadge numb"
        self.limitField.delegate = controller
        self.limitField.isEditable = true
        self.limitField.allowsEditingTextAttributes = true
        self.limitField.tag = 1
        
        controller.view.addSubview(self.limitField)
        
        self.timeLabel.frame = NSRect(x: 0, y: 90, width: 200, height: 30)
        self.timeLabel.backgroundColor = .gray
        self.timeLabel.textColor = .black
        self.timeLabel.isEnabled = false
        self.timeLabel.placeholderString = "Time: "
        self.timeLabel.delegate = controller
        controller.view.addSubview(self.timeLabel)
        
        self.collectedLabel.frame = NSRect(x: 0, y: 120, width: 200, height: 30)
        self.collectedLabel.backgroundColor = .gray
        self.collectedLabel.textColor = .black
        self.collectedLabel.isEnabled = false
        self.collectedLabel.placeholderString = "Collected: "
        self.collectedLabel.delegate = controller
        controller.view.addSubview(self.collectedLabel)
        
        self.energyLabel.frame = NSRect(x: 0, y: 150, width: 200, height: 30)
        self.energyLabel.backgroundColor = .gray
        self.energyLabel.textColor = .black
        self.energyLabel.isEnabled = false
        self.energyLabel.placeholderString = "Energy: "
        self.energyLabel.delegate = controller
        controller.view.addSubview(self.energyLabel)
    }
    
    func setupManager() {
        let manager = MapManager(mapType: .roomWithBlocks, garbadgeLimit: Int(self.limit) ?? 0)
        self.mapManager = manager
        self.secondLimit = Float(self.maxTime) ?? 0.0
        self.secondCounter = 0
        self.garbagdeNumber = 0
    }
    
    var isStart = true
    
    func startGame() {
        self.setupManager()
        self.garbagdeNumber = self.mapManager?.garbadgeCount ?? 0
        let timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { (timer) in
            guard let manager = self.mapManager else { return }
            
            if self.isStart {
                self.isStart = false
            } else {
                

//              manager.moveRandom()

                if manager.isHavePath {
                    manager.moveAgent()
                } else if !manager.isSearchingPath {
                    manager.findNewPath()
                }
            }
            
            
            self.removeAllChildren()
            
            for i in 0..<manager.map.count {
                for j in 0..<manager.map[i].count {
                    let rect = CGRect(x: (i * self.scale), y: (j * self.scale), width: self.scale, height: self.scale)
                    let shape = SKShapeNode(rect: rect)
                    let value = manager.map[i][j].value
                    
                    switch value {
                        case AppConstants.garbage:
                            shape.fillColor = .brown
                        case AppConstants.agent:
                            shape.fillColor = .green
                        case AppConstants.wall:
                            shape.fillColor = .gray
                        case AppConstants.mapVoid:
                            shape.fillColor = .white
                        default: ()
                    }
                    
                    self.addChild(shape)
                    
                }
            }
            
            //ANALYTICS
            self.secondCounter += 1
            if self.secondCounter >= self.secondLimit || !manager.isHaveGarbadge {
                timer.invalidate()
            }
            
            self.garbadgeCounter = self.garbagdeNumber - manager.garbadgeCount
            self.timeLabel.stringValue = "Seconds = \(self.secondCounter)"
            
            self.collectedLabel.stringValue = "Collected = \(self.garbadgeCounter), clean = \(manager.persentOfClean)%"
            self.energyLabel.stringValue = "Energy: \(manager.energyConsumed)"
        }
        timer.fire()
    }
    
    override func update(_ currentTime: TimeInterval) {
    }
}
