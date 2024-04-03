//
//  GameOverScene.swift
//  NC2Dominoes
//
//  Created by Danilo Luongo on 12/12/23.
//

import SwiftUI
import SpriteKit

class GameOverScene : SKScene {
    
    let gameoverSound = SKAction.playSoundFileNamed("game-over-arcade-6435", waitForCompletion: false)
    
    override func didMove(to view: SKView) {
        run(gameoverSound)
        
        let scoreLabel = (self.childNode(withName: "//scoreLabel") as! SKLabelNode)
        scoreLabel.text = "Score: \(Int(MyScene.score))"
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
         for touch in touches {
             let location = touch.location(in: self)
             let touchedNode = atPoint(location)
             if touchedNode.name == "PlayButton" {
                 let scene = SKScene(fileNamed: "MyScene")!
                 self.view?.presentScene(scene)
             }
             else if touchedNode.name == "MenuButton" {
                 let scene = SKScene(fileNamed: "MainScene")!
                 self.view?.presentScene(scene)
             }
         }
    }
}
