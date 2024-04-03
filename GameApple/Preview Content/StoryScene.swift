//
//  StoryScene.swift
//  NC2Dominoes
//
//  Created by Elena Volkova on 15/12/23.
//

import SwiftUI
import SpriteKit

class StoryScene : SKScene {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
         for touch in touches {
              let location = touch.location(in: self)
              let touchedNode = atPoint(location)
              if touchedNode.name == "MenuButton" {
                  let scene = SKScene(fileNamed: "MainScene")!
                  self.view?.presentScene(scene)
              }
         }
    }
}
