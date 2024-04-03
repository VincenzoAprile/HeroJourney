//
//  MyScene.swift
//  NC2Dominoes
//
//  Created by Danilo Luongo on 07/12/23.
//

import SpriteKit
import SwiftUI

struct PhysicsCategory {
    static let none     : UInt32 = 0
    static let all      : UInt32 = UInt32.max
    static let player   : UInt32 = 0b1
    static let ground   : UInt32 = 0b10
    static let enemy   : UInt32 = 0b11
    static let collectible: UInt32 = 0b100
}

class MyScene : SKScene {
    
    @AppStorage("topScore") static var topScore = 0

    var firstUpdate : TimeInterval = 0
    var lastUpdateTime : TimeInterval = 0
    var obstacleDelayCounter : TimeInterval = 0
    var slideDelayCounter : TimeInterval = 0
    
    var enemy: SKSpriteNode!
    var hero: SKSpriteNode!
    var acorn: SKSpriteNode!
    var scoreLabel: SKLabelNode!
    
    var canHeroJump : Bool = true
    var slide : Bool = false
    var startTouchLocation : CGPoint? = nil
    static var score : Float = 0
    var saveSpeed : CGFloat = 0
    let backgroundSound = SKAudioNode(fileNamed: "Loop_music")
        
    
    func createBackgroundLayers() {
        for i in 1 ... 3 {
            let backgroundTexture = SKTexture(imageNamed: "Forest_\(i)")
            
            let background1 = SKSpriteNode(texture: backgroundTexture)
            let background2 = SKSpriteNode(texture: backgroundTexture)
            background1.zPosition = CGFloat(-30 + 5 * i)
            background2.zPosition = CGFloat(-30 + 5 * i)
            background1.size = CGSize(width: 852, height: 426.427)
            background2.size = CGSize(width: 852, height: 426.427)
            background1.position = CGPoint(x: 0, y: 0)
            background2.position = CGPoint(x: 852, y: 0)
            addChild(background1)
            addChild(background2)
            let moveLeft = SKAction.moveBy(x: -852, y: 0, duration: CGFloat(15 - 2 * i))
            let moveReset = SKAction.moveBy(x: 852, y: 0, duration: 0)
            let moveLoop = SKAction.sequence([moveLeft, moveReset])
            let moveForever = SKAction.repeatForever(moveLoop)

            background1.run(moveForever)
            background2.run(moveForever)
        }
    }
    
    func createGround() {
        for i in 0 ... 5 {
            let groundTexture = SKTexture(imageNamed: "Plat02")
            
            let ground = SKSpriteNode(texture: groundTexture)
            ground.name = "ground"
            ground.zPosition = CGFloat(1)
            ground.size = CGSize(width: 188, height: 48)
            ground.position = CGPoint(x: Double(-332 + i * 188), y: -172.5)
            
            ground.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 188, height: 48))
            ground.physicsBody?.affectedByGravity = false
            ground.physicsBody?.allowsRotation = false
            ground.physicsBody?.isDynamic = false
            ground.physicsBody?.categoryBitMask = PhysicsCategory.ground
            ground.physicsBody?.contactTestBitMask = PhysicsCategory.player
            ground.physicsBody?.collisionBitMask = PhysicsCategory.player
            
            let yRange = SKRange(lowerLimit: -172.5, upperLimit: -172.5)
            let yConstraint = SKConstraint.positionY(yRange)
            ground.constraints = [yConstraint]
            
            addChild(ground)
            
            let moveLeft = SKAction.moveBy(x: -188, y: 0, duration: CGFloat(0.5))
            let moveReset = SKAction.moveBy(x: 188, y: 0, duration: 0)
            let moveLoop = SKAction.sequence([moveLeft, moveReset])
            let moveForever = SKAction.repeatForever(moveLoop)

            ground.run(moveForever)
        }
    }
    
    func createObstacle() {
        let spawnProbability = Int.random(in: 1..<101)
        if spawnProbability <= 33 {
            let obstacleTexture = SKTexture(imageNamed: "Rock_1")
            let obstacle = SKSpriteNode(texture: obstacleTexture)
            
            obstacle.name = "rock"
            obstacle.zPosition = 1
            obstacle.size = CGSize(width: 60, height: 33)
            
            obstacle.position = CGPoint(x: Double(608), y: -170)
            
            obstacle.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 5, height: 33))
            obstacle.physicsBody?.affectedByGravity = true
            obstacle.physicsBody?.allowsRotation = false
            obstacle.physicsBody?.categoryBitMask = PhysicsCategory.enemy
            obstacle.physicsBody?.contactTestBitMask = PhysicsCategory.player
            obstacle.physicsBody?.collisionBitMask = PhysicsCategory.ground
            
            addChild(obstacle)
            
            let moveLeft = SKAction.moveBy(x: -928, y: 0, duration: CGFloat(2.5))

            obstacle.run(moveLeft)
        }
        else if spawnProbability <= 40{
            
            let obstacleTexture = SKTexture(imageNamed: "Crate_1")
            let obstacle = SKSpriteNode(texture: obstacleTexture)
            
            obstacle.name = "crate"
            obstacle.zPosition = 1
            obstacle.size = CGSize(width: 60, height: 33)
            
            obstacle.position = CGPoint(x: Double(608), y: -170)
            
            obstacle.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 5, height: 33))
            obstacle.physicsBody?.affectedByGravity = true
            obstacle.physicsBody?.allowsRotation = false
            obstacle.physicsBody?.categoryBitMask = PhysicsCategory.enemy
            obstacle.physicsBody?.contactTestBitMask = PhysicsCategory.player
            obstacle.physicsBody?.collisionBitMask = PhysicsCategory.ground
            
            addChild(obstacle)
            
            let moveLeft = SKAction.moveBy(x: -928, y: 0, duration: CGFloat(2.5))

            obstacle.run(moveLeft)
            
        }
        else if spawnProbability <= 50 {
            let collectibleTexture = SKTexture(imageNamed: "Coin")
            let collectible = SKSpriteNode(texture: collectibleTexture)
            
            collectible.name = "coin"
            collectible.zPosition = 1
            collectible.size = CGSize(width: 32, height: 32)
            
            collectible.position = CGPoint(x: Double(608), y: -170)
            
            collectible.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 10, height: 32))
            collectible.physicsBody?.affectedByGravity = true
            collectible.physicsBody?.allowsRotation = false
            collectible.physicsBody?.categoryBitMask = PhysicsCategory.collectible
            collectible.physicsBody?.contactTestBitMask = PhysicsCategory.player
            collectible.physicsBody?.collisionBitMask = PhysicsCategory.ground
            
            addChild(collectible)
            
            let moveLeft = SKAction.moveBy(x: -928, y: 0, duration: CGFloat(2.5))

            collectible.run(moveLeft)
        }
        else if spawnProbability <= 75 {
            let obstacleTexture = SKTexture(imageNamed: "moss")
            
            let obstacle = SKSpriteNode(texture: obstacleTexture)
            
            obstacle.name = "moss"
            obstacle.zPosition = 1
            obstacle.size = CGSize(width: 64, height: 20)
            
            obstacle.position = CGPoint(x: Double(608), y: -170)
            
            obstacle.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 32, height: 20))
            obstacle.physicsBody?.affectedByGravity = true
            obstacle.physicsBody?.allowsRotation = false
            obstacle.physicsBody?.categoryBitMask = PhysicsCategory.enemy
            obstacle.physicsBody?.contactTestBitMask = PhysicsCategory.player
            obstacle.physicsBody?.collisionBitMask = PhysicsCategory.ground
            
            addChild(obstacle)
            
            let moveLeft = SKAction.moveBy(x: -928, y: 0, duration: CGFloat(2.5))

            obstacle.run(moveLeft)
        }
        else if spawnProbability <= 100 {
            let obstacleTexture = SKTexture(imageNamed: "tile00")
            let anim = SKAction.animate(with: [SKTexture(imageNamed: "tile00"), SKTexture(imageNamed: "tile01"), SKTexture(imageNamed: "tile02"), SKTexture(imageNamed: "tile03"), SKTexture(imageNamed: "tile04"), SKTexture(imageNamed: "tile05"), SKTexture(imageNamed: "tile06"), SKTexture(imageNamed: "tile07")], timePerFrame: 0.08)
            
            let obstacle = SKSpriteNode(texture: obstacleTexture)
            let loop = SKAction.repeatForever(anim)
            
            obstacle.name = "eyebat"
            obstacle.zPosition = 1
            obstacle.size = CGSize(width: 300, height: 300)
            obstacle.xScale = -1.0
            
            obstacle.position = CGPoint(x: Double(608), y: -75)
            
            obstacle.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 20, height: 20))
            obstacle.physicsBody?.affectedByGravity = false
            obstacle.physicsBody?.allowsRotation = false
            obstacle.physicsBody?.categoryBitMask = PhysicsCategory.enemy
            obstacle.physicsBody?.contactTestBitMask = PhysicsCategory.player
            obstacle.physicsBody?.collisionBitMask = PhysicsCategory.ground
            
            addChild(obstacle)
            
            let moveLeft = SKAction.moveBy(x: -928, y: 0, duration: CGFloat(2.5))

            obstacle.run(moveLeft)
            obstacle.run(loop)
        }
    }
    
    override func didMove(to view: SKView) {
        MyScene.score = 0
        self.speed = 1.0
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0, dy: -15)
        
        createBackgroundLayers()
        createGround()
        
        /* Recursive node search for 'hero' (child of referenced node) */
        hero = (self.childNode(withName: "//hero") as! SKSpriteNode)
        enemy = (self.childNode(withName: "//enemy") as! SKSpriteNode)
        hero.physicsBody?.categoryBitMask = PhysicsCategory.player
        enemy.physicsBody?.categoryBitMask = PhysicsCategory.player
        hero.physicsBody?.collisionBitMask = PhysicsCategory.ground
        
        let xRange = SKRange(lowerLimit: 0, upperLimit: 0)
        let xConstraint = SKConstraint.positionX(xRange)
        hero.constraints = [xConstraint]
        scoreLabel = (self.childNode(withName: "//scoreLabel") as! SKLabelNode)

        /* allows the hero and enemy to animate when it's in the GameScene */
        hero.isPaused = false
        enemy.isPaused = false
        
        self.addChild(backgroundSound)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        startTouchLocation = location
        let touchedNode = atPoint(location)
        if touchedNode.name == "PauseButton" {
            if saveSpeed == 0 {
                saveSpeed = self.speed
                self.speed = 0
                hero.physicsBody?.isDynamic = false
                backgroundSound.run(SKAction.stop())

            }
            else {
                self.speed = saveSpeed
                saveSpeed = -1
                hero.physicsBody?.isDynamic = true
                backgroundSound.run(SKAction.play())

            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        if location.y - startTouchLocation!.y < -50 && !slide && saveSpeed == 0 {
            toggleSlide(toggle: true)
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //guard let touch = touches.first else { return }
        //let location = touch.location(in: self)
        if canHeroJump && !slide && saveSpeed == 0 {
            hero.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: 75.0))
            canHeroJump = false
        }
        else if saveSpeed == -1 {
            saveSpeed = 0
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        let deltaTime = calculateDeltaTime(from: currentTime)
        
        if self.firstUpdate == 0 { self.firstUpdate = currentTime }
        
        if saveSpeed == 0 {
            MyScene.score += Float(deltaTime * 2 * self.speed)
            scoreLabel.text = "\(Int(MyScene.score))"
            
            //Random generation of obstacles
            obstacleDelayCounter += deltaTime
            if obstacleDelayCounter >= (1.5 / self.speed) {
                createObstacle()
                self.speed += 0.01
                obstacleDelayCounter = 0.0
            }
            if slide {
                slideDelayCounter += deltaTime
                if slideDelayCounter >= 0.5 {
                    toggleSlide(toggle: false)
                    slideDelayCounter = 0.0
                }
            }
        }
    }
    
    private func calculateDeltaTime(from currentTime: TimeInterval) -> TimeInterval {
        // When the level is started or after the game has been paused, the last update time is reset to the current time.
        if lastUpdateTime.isZero {
          lastUpdateTime = currentTime
        }

        // Calculate delta time since `update` was last called.
        let deltaTime = currentTime - lastUpdateTime

        // Use current time as the last update time on next game loop update.
        lastUpdateTime = currentTime

        return deltaTime
      }
    
    func toggleSlide(toggle: Bool) {
        slide = toggle
        let anim : SKAction
        if toggle {
            anim = SKAction.animate(with: [SKTexture(imageNamed: "tile038")], timePerFrame: 1)
            
        }
        else {
            anim = SKAction.animate(with: [SKTexture(imageNamed: "tile016"), SKTexture(imageNamed: "tile017"), SKTexture(imageNamed: "tile018"), SKTexture(imageNamed: "tile019"), SKTexture(imageNamed: "tile020"), SKTexture(imageNamed: "tile021"), SKTexture(imageNamed: "tile022"), SKTexture(imageNamed: "tile023")], timePerFrame: 0.08)
        }
        let loop = SKAction.repeatForever(anim)
        hero.run(loop)
    }
    
    func gameOver() {
        if Int(MyScene.score) > MyScene.topScore {
            MyScene.topScore = Int(MyScene.score)
        }
        hero.removeFromParent()
        let scene = SKScene(fileNamed: "GameOverScene")!
        let transition = SKTransition.moveIn(with: .right, duration: 1)
        self.view?.presentScene(scene, transition: transition)
    }
}

extension MyScene : SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody: SKPhysicsBody = contact.bodyA
        let secondBody: SKPhysicsBody = contact.bodyB
        
        if let node = firstBody.node, node.name == "ground" && secondBody.node?.name == "hero" {
            canHeroJump = true
        }
        
        if let node = firstBody.node, node.name == "rock" && secondBody.node?.name == "hero" {
            node.removeFromParent()
            gameOver()
        }
        
        if let node = firstBody.node, node.name == "crate" && secondBody.node?.name == "hero" {
            node.removeFromParent()
            gameOver()
        }
        
        if let node = firstBody.node, node.name == "eyebat" && secondBody.node?.name == "hero" && !slide {
            node.removeFromParent()
            gameOver()
        }
        
        if let node = firstBody.node, node.name != "ground" && secondBody.node?.name == "enemy" {
            node.removeFromParent()
        }
        
        if let node = firstBody.node, node.name == "coin" && secondBody.node?.name == "hero" {
            node.removeFromParent()
            MyScene.score += 100
            let gainAcronSound = SKAction.playSoundFileNamed("gain-coin", waitForCompletion: false)
            run(gainAcronSound)
        }
        
        if let node = firstBody.node, node.name == "moss" && secondBody.node?.name == "hero" {
            node.removeFromParent()
            let moveRight = SKAction.moveBy(x: 100, y: 0, duration: CGFloat(0.5))
            let wait = SKAction.wait(forDuration: 2.0)
            let moveLeft = SKAction.moveBy(x: -100, y: 0, duration: CGFloat(0.5))
            let danger = SKAction.sequence([moveRight, wait, moveLeft])
            enemy.run(danger)
        }
    }
}
