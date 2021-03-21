//
//  ViewController.swift
//  Agent
//
//  Created by Roman Mishchenko on 03.03.2021.
//

import Cocoa
import SpriteKit
import GameplayKit

class ViewController: NSViewController {

    @IBOutlet var skView: SKView!
    
    let scene = SKScene(fileNamed: "GameScene")
    let button = NSButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(self.button)
        button.frame = NSRect(x: 0, y: 0, width: 100, height: 30)
        button.target = self
        button.action = #selector(buttonTest)
        button.title = "Start"
        
        self.scene?.scaleMode = .aspectFit
        guard let safeScene = self.scene as? GameScene else { return }
        safeScene.prepare(controller: self)
    }
    
    @objc func buttonTest() {
        if let view = self.skView {
            guard let safeScene = self.scene as? GameScene else { return }
            safeScene.startGame()
            // Present the scene
            view.presentScene(safeScene)
        }
    }
}

extension ViewController: NSTextFieldDelegate {
    func control(_ control: NSControl, textShouldEndEditing fieldEditor: NSText) -> Bool {
 
        if let textField = control as? NSTextField, let safeScene = self.scene as? GameScene {
            switch textField.tag {
                case 1:
                    safeScene.limit = textField.stringValue
                case 2:
                    safeScene.maxTime = textField.stringValue
                default: ()
            }
        }
        
 
        return true
    }
}
