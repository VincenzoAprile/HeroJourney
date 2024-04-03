//
//  MainScene.swift
//  NC2Dominoes
//
//  Created by Danilo Luongo on 12/12/23.
//

import SwiftUI
import SpriteKit

class MainScene : SKScene {
    
    override func didMove(to view: SKView) {
        let scoreLabel = (self.childNode(withName: "//scoreLabel") as! SKLabelNode)
        scoreLabel.text = "Top score: \(Int(MyScene.topScore))"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
         for touch in touches {
              let location = touch.location(in: self)
              let touchedNode = atPoint(location)
              if touchedNode.name == "PlayButton" {
                  let scene = SKScene(fileNamed: "MyScene")!
                  self.view?.presentScene(scene)
              }
             else if touchedNode.name == "RulesButton" {
                 let scene = SKScene(fileNamed: "OnboardingScene")!
                 self.view?.presentScene(scene)
             }
         }
    }
}
