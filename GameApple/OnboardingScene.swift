//
//  HistoryScene.swift
//  NC2Dominoes
//
//  Created by Vincenzo Aprile on 18/12/23.
//

import SwiftUI
import SpriteKit

class OnboardingScene : SKScene {
    
    var knight: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        knight = (self.childNode(withName: "//knight") as! SKSpriteNode)
        knight.isPaused = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
         for touch in touches {
              let location = touch.location(in: self)
              let touchedNode = atPoint(location)
              if touchedNode.name == "MenuButton" {
                  let scene = SKScene(fileNamed: "StoryScene")!
                  self.view?.presentScene(scene)
              }
         }
    }
}
