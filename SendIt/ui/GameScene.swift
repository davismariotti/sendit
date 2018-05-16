//
//  GameScene.swift
//  SendIt
//
//  Created by gomeow on 3/12/18.
//  Copyright © 2018 Davis and Jesenia Inc. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {

    var touched = false
    var location = CGPoint.zero
    var background: SKSpriteNode = SKSpriteNode(imageNamed: "background")
    var background2: SKSpriteNode = SKSpriteNode(imageNamed: "background")

    var climber: SKSpriteNode = SKSpriteNode(imageNamed: "climbergirl1")
    var climberCharacter: String = "girl"
    var climberState = true

    var gameOver = false
    var score: Double = 0
    var scoreLabel: SKLabelNode = SKLabelNode(text: "0")

    let endGameLabel: SKLabelNode = SKLabelNode(text: "Game Over")
    let menuButtonLabel = SKLabelNode(text: "Main Menu")
    let resetButtonLabel = SKLabelNode(text: "Reset")

    var pointNodes: [SKShapeNode] = []

    var spider: SKSpriteNode = SKSpriteNode(imageNamed: "spider")
    var spiderTimer: Timer!

    var cave: SKShapeNode = SKShapeNode(rectOf: CGSize(width: 100, height: 200))

    // Bit masks for collisions and contacts
    let pointCategory: UInt32 = 0x1 << 0
    let climberCategory: UInt32 = 0x1 << 1
    let spiderCategory: UInt32 = 0x1 << 2
    let caveCategory: UInt32 = 0x1 << 3

    let backgroundSpeed: CGFloat = 4.0

    var gameDelegate: GameSceneDelegate?


    enum Direction {
        case up, down
    }

    override func didMove(to view: SKView) {

        // Add backgrounds
        background.size = frame.size
        background.position = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2)
        addChild(background)
        background2.size = frame.size
        background2.position = CGPoint(x: self.frame.size.width * 1.5, y: self.frame.size.height * 1.5)
        addChild(background2)


        // Use choosen avatar
        let choosenAvatar = UserDefaults.standard.string(forKey: "character")
        if choosenAvatar == nil || choosenAvatar == "girl" {
            self.climberCharacter = "girl"
             self.climber.texture = SKTexture(imageNamed: "climbergirl1")
        } else {
            self.climberCharacter = "boy"
            self.climber.texture = SKTexture(imageNamed: "climberboy1")
        }

        // Add climber
        climber.position = CGPoint(x: view.frame.size.width / 2, y: view.frame.size.height / 2)
        climber.physicsBody = SKPhysicsBody(rectangleOf: climber.size)
        climber.physicsBody?.usesPreciseCollisionDetection = true
        climber.physicsBody?.categoryBitMask = self.climberCategory
        climber.physicsBody?.contactTestBitMask = self.pointCategory
        climber.physicsBody?.collisionBitMask = 0
        climber.physicsBody?.affectedByGravity = false
        climber.name = "climber"
        climber.zPosition = 8
        addChild(climber)


        // Add labels
        scoreLabel.position = CGPoint(x: view.frame.size.width - 20, y: 20)
        scoreLabel.fontColor = SKColor.white
        scoreLabel.fontName = "8BITWONDERNominal"
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.zPosition = 6
        addChild(scoreLabel)

        endGameLabel.position = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2)
        endGameLabel.fontColor = SKColor.white
        endGameLabel.fontName = "8BITWONDERNominal"
        endGameLabel.horizontalAlignmentMode = .center
        endGameLabel.zPosition = 6

        menuButtonLabel.fontColor = SKColor.white
        menuButtonLabel.fontName = "8BITWONDERNominal"
        menuButtonLabel.fontSize = 14
        menuButtonLabel.position = CGPoint(x: 10, y: 20)
        menuButtonLabel.horizontalAlignmentMode = .left
        menuButtonLabel.zPosition = 6
        addChild(menuButtonLabel)

        resetButtonLabel.fontColor = SKColor.white
        resetButtonLabel.fontName = "8BITWONDERNominal"
        resetButtonLabel.fontSize = 15
        resetButtonLabel.position = endGameLabel.position.applying(CGAffineTransform(translationX: 0, y: -100))
        resetButtonLabel.horizontalAlignmentMode = .center
        resetButtonLabel.zPosition = 6


        for _ in 0...5 {
            createPointNode()
        }

        // Add spider
        spider.position = CGPoint(x: view.frame.size.width * 0.85, y: view.frame.size.height + 100)
        spider.physicsBody = SKPhysicsBody(rectangleOf: spider.size)
        spider.physicsBody?.usesPreciseCollisionDetection = true
        spider.physicsBody?.categoryBitMask = self.spiderCategory
        spider.physicsBody?.collisionBitMask = 0
        spider.physicsBody?.contactTestBitMask = self.climberCategory
        spider.physicsBody?.affectedByGravity = false
        spider.name = "spider"
        spider.zPosition = 5
        addChild(spider)

        let web = SKShapeNode(rect: CGRect(x: 0, y: 0, width: 1, height: self.frame.size.height))
        spider.addChild(web)

        spiderTimer = Timer.scheduledTimer(withTimeInterval: 7, repeats: true) {_ in
            let downPoint = CGPoint(x: Double(self.spider.position.x), y: Double(self.frame.size.height / 3) + self.rand(withMultiplier: Double(self.frame.size.height / 2)))

            let moveDownAction = SKAction.move(to: downPoint, duration: 1.5)
            let waitAction = SKAction.wait(forDuration: 2)

            let moveUpAction = SKAction.move(to: CGPoint(x: Double(self.spider.position.x), y: Double(self.frame.size.height) + 100), duration: 1.5)

            let moveSequence = SKAction.group([moveDownAction, waitAction])

            self.spider.run(moveSequence) {
                self.spider.run(moveUpAction) {
                    let moveSideAction = SKAction.move(to: CGPoint(x: 50 + self.rand(withMultiplier: Double(self.frame.size.width - 100)), y: Double(self.frame.size.height) + 100), duration: 0.1)
                    self.spider.run(moveSideAction)
                }
            }
        }

        // Add cave
        cave.position = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height + 300)
        cave.fillColor = .black
        cave.lineWidth = 0
        cave.zPosition = 4
        cave.physicsBody = SKPhysicsBody(rectangleOf: cave.frame.size)
        cave.physicsBody?.usesPreciseCollisionDetection = true
        cave.physicsBody?.categoryBitMask = self.caveCategory
        cave.physicsBody?.contactTestBitMask = self.climberCategory
        cave.physicsBody?.collisionBitMask = 0
        cave.physicsBody?.affectedByGravity = false
        cave.name = "cave"
        addChild(cave)


        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) {_ in
            if self.touched {
                if self.climberState {
                    if self.climberCharacter == "girl" {
                        self.climber.texture = SKTexture(imageNamed: "climbergirl1")
                    } else {
                        self.climber.texture = SKTexture(imageNamed: "climberboy1")
                    }
                    self.climberState = false
                } else {
                    if self.climberCharacter == "girl" {
                        self.climber.texture = SKTexture(imageNamed: "climbergirl2")
                    } else {
                        self.climber.texture = SKTexture(imageNamed: "climberboy2")
                    }
                    self.climberState = true
                }
            }

        }
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsBody?.affectedByGravity = false

        physicsWorld.contactDelegate = self
    }

    // MARK: - Collisions

    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }

        if contact.bodyA.node?.name == "climber" && contact.bodyB.node?.name == "point" {
            pointHit(climber: nodeA as! SKSpriteNode, object: nodeB)
        } else if contact.bodyB.node?.name == "climber" && contact.bodyA.node?.name == "point" {
            pointHit(climber: nodeB as! SKSpriteNode, object: nodeA)
        } else if contact.bodyA.node?.name == "climber" && contact.bodyB.node?.name == "spider" {
            spiderHit(climber: nodeA as! SKSpriteNode, spider: nodeB as! SKSpriteNode)
        } else if contact.bodyB.node?.name == "climber" && contact.bodyA.node?.name == "spider" {
            spiderHit(climber: nodeB as! SKSpriteNode, spider: nodeA as! SKSpriteNode)
        } else if contact.bodyA.node?.name == "climber" && contact.bodyB.node?.name == "cave" {
            caveHit(climber: nodeA as! SKSpriteNode, cave: nodeB)
        } else if contact.bodyB.node?.name == "climber" && contact.bodyA.node?.name == "cave" {
            caveHit(climber: nodeB as! SKSpriteNode, cave: nodeA)
        }
    }

    func pointHit(climber: SKSpriteNode, object: SKNode) {
        if object is SKShapeNode {
            if !gameOver {
                score += 10
            }
            object.removeFromParent()
            pointNodes.remove(at: pointNodes.index(of: object as! SKShapeNode)!)
            createPointNode()
        }
    }

    func spiderHit(climber: SKSpriteNode, spider: SKSpriteNode) {
        doGameOver()
    }

    func caveHit(climber: SKSpriteNode, cave: SKNode) { // TODO
        doGameOver()
    }

    // MARK: - Frame update

    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        moveClimber()
        scoreLabel.text = String(Int(score))

    }

    // MARK: - Touches

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let touchLocation = touch.location(in: self)
            let touchedNodes = self.nodes(at: touchLocation)
            if touchedNodes.contains(resetButtonLabel) {
                resetGame()
                return
            } else if touchedNodes.contains(menuButtonLabel) {
                goToMenu()
                return
            }
            location = touch.location(in: view)
            touched = true
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            location = touch.location(in: view)

        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touched = false
    }

    // MARK: - Point Nodes

    func createPointNode() {
        let pointNode = SKShapeNode(rect: CGRect(x: 0, y: 0, width: 10, height: 10))

        // Physics
        pointNode.physicsBody = SKPhysicsBody(rectangleOf: pointNode.frame.size)
        pointNode.physicsBody?.usesPreciseCollisionDetection = true
        pointNode.physicsBody?.isDynamic = false
        pointNode.physicsBody?.affectedByGravity = false
        pointNode.zPosition = 3
        pointNode.name = "point"

        pointNode.position = CGPoint(x: rand(withMultiplier: Double(self.frame.width)), y: Double(self.frame.height) + rand(withMultiplier: 200))

        addChild(pointNode)
        pointNode.fillColor = .yellow
        pointNodes.append(pointNode)
    }

    func movePointNodes() {
        for node in pointNodes {
            if node.position.y > -20 {
                node.position = CGPoint(x: node.position.x, y: node.position.y - self.backgroundSpeed)
            } else {
                node.position = CGPoint(x: rand(withMultiplier: Double(self.frame.width)), y: Double(self.frame.height) + rand(withMultiplier: 200))
            }
        }
    }

    // MARK: - Move climber

    func moveClimber() {
        if touched && !gameOver {
            // First move horizontally
            let horizontalSpeed: CGFloat = (location.x - climber.position.x) / 20
            let verticalSpeed: CGFloat = ((self.frame.size.height - location.y) - climber.position.y) / 20
            let newLocationX = climber.position.x + horizontalSpeed
            var newLocationY = climber.position.y

            newLocationY = climber.position.y + verticalSpeed
            if newLocationY < 150 {
                newLocationY = 150
            }
            if newLocationY > self.frame.size.height - 250 {
                newLocationY = self.frame.size.height - 250
                moveBackground(direction: .down, speed: self.backgroundSpeed)
            }

            climber.position = CGPoint(x: newLocationX, y: newLocationY)
        }
    }

    // MARK: - Move background

    func moveBackground(direction: Direction, speed: CGFloat) {
        movePointNodes()
        moveCave()
        if !gameOver {
            score += 0.04
        }
        background.position = CGPoint(x: self.frame.size.width / 2, y: background.position.y - speed)
        if background.frame.maxY <= 0 {
            background.position = CGPoint(x: self.frame.size.width / 2, y: view!.frame.size.height * 1.5)
        }
        background2.position = CGPoint(x: self.frame.size.width / 2, y: background2.position.y - speed)
        if background2.frame.maxY <= 0 {
            background2.position = CGPoint(x: self.frame.size.width / 2, y: view!.frame.size.height * 1.5)
        }
    }

    // MARK: - Move Cave

    func moveCave() {
        if cave.position.y > -200 {
            cave.position = CGPoint(x: cave.position.x, y: cave.position.y - self.backgroundSpeed)
        } else {
            cave.position = CGPoint(x: rand(withMultiplier: Double(self.frame.size.width)), y: Double(self.frame.size.height) + 200 + rand(withMultiplier: 300))
        }
    }

    // MARK: - Game over logic

    func doGameOver() {
        if !self.children.contains(endGameLabel) {
            addChild(endGameLabel)
            addChild(resetButtonLabel)
            gameOver = true
            climber.physicsBody?.affectedByGravity = true
            climber.physicsBody?.applyImpulse(CGVector(dx: 35, dy: 250))
        }

        NetworkManager.sendScore(score: Int(score)) {
        (success) -> Void in
            if !success {
                print("Send score error!")
            }
        }
    }

    func resetGame() {
        climber.physicsBody?.affectedByGravity = false
        climber.position = CGPoint(x: self.view!.frame.size.width / 2, y: self.view!.frame.size.height / 2)
        climber.physicsBody?.velocity = CGVector.zero
        score = 0
        gameOver = false
        endGameLabel.removeFromParent()
        resetButtonLabel.removeFromParent()
    }

    func goToMenu() {
        self.gameDelegate?.returnToMainMenu()
    }

    // MARK: - Miscellaneous

    func rand(withMultiplier multiplier: Double) -> Double {
        return drand48() * multiplier
    }
}
