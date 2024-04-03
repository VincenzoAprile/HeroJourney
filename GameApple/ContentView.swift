//
//  ContentView.swift
//  GameApple
//
//  Created by Vincenzo Aprile on 21/03/24.
//

import SwiftUI
import SpriteKit

// A sample SwiftUI creating a GameScene and sizing it
// at 300x400 points
struct ContentView: View {
    
    @AppStorage("onboarding") var onboarding = true
    
    var scene : SKScene {
        if onboarding {
            onboarding = false
            return SKScene(fileNamed: "OnboardingScene")!///////////jdin
        }
        else {
            return SKScene(fileNamed: "MainScene")!
        }
    }

    var body: some View {
        SpriteView(scene: scene)
            //.scaledToFill()
            //.frame(width: 300, height: 400)
            .ignoresSafeArea()
    }
}
