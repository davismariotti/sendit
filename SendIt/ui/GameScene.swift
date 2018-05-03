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
    var climberState = true
    var score: Int = 0
    var scoreLabel: SKLabelNode = SKLabelNode(text: "0")
    let endGameLabel: SKLabelNode = SKLabelNode(text: "Game Over")
    var gameOver = false
    var pointNodes: [SKShapeNode] = []
    var spider: SKSpriteNode = SKSpriteNode(imageNamed: "spider")
    var spiderTimer: Timer!

    let pointCategory: UInt32 = 0x1 << 0
    let climberCategory: UInt32 = 0x1 << 1
    let spiderCategory: UInt32 = 0x1 << 2

    let backgroundSpeed: CGFloat = 4.0


    enum Direction {
        case up, down
    }

    override func didMove(to view: SKView) {
        background.size = frame.size
        background.position = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2)
        addChild(background)
        background2.size = frame.size
        background2.position = CGPoint(x: self.frame.size.width * 1.5, y: self.frame.size.height * 1.5)
        addChild(background2)


        climber.position = CGPoint(x: view.frame.size.width / 2, y: view.frame.size.height / 2)
        climber.physicsBody = SKPhysicsBody(rectangleOf: climber.size)
//        SKPhysicsBody(polygonFrom: CGPath()
        climber.physicsBody?.usesPreciseCollisionDetection = true
        climber.physicsBody?.categoryBitMask = self.climberCategory
        climber.physicsBody?.contactTestBitMask = self.pointCategory
        climber.physicsBody?.collisionBitMask = 0
        climber.physicsBody?.affectedByGravity = false
        climber.name = "climber"
        addChild(climber)

        scoreLabel.position = CGPoint(x: view.frame.size.width - 20, y: 20)
        scoreLabel.fontColor = SKColor.white
        scoreLabel.fontName = "8BITWONDERNominal"
        scoreLabel.horizontalAlignmentMode = .right
        addChild(scoreLabel)

        endGameLabel.position = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2)
        endGameLabel.fontColor = SKColor.white
        endGameLabel.fontName = "8BITWONDERNominal"
        endGameLabel.horizontalAlignmentMode = .center

        for _ in 0...5 {
            createPointNode()
        }

        spider.position = CGPoint(x: view.frame.size.width * 0.85, y: view.frame.size.height * 0.75)
        spider.physicsBody = SKPhysicsBody(rectangleOf: spider.size)
        spider.physicsBody?.usesPreciseCollisionDetection = true
        spider.physicsBody?.categoryBitMask = self.spiderCategory
        spider.physicsBody?.collisionBitMask = 0
        spider.physicsBody?.contactTestBitMask = self.climberCategory
        spider.physicsBody?.affectedByGravity = false
        spider.name = "spider"
        addChild(spider)

        spiderTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) {_ in
            let moveDownAction = SKAction.moveBy(x: 0, y: -300, duration: 1)
            let moveUpAction = SKAction.moveBy(x: 0, y: 300, duration: 1)
            let sequence1 = SKAction.group([moveDownAction, moveUpAction])
            self.spider.run(sequence1)
        }


        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) {_ in
            if self.touched {
                if self.climberState {
                    self.climber.texture = SKTexture(imageNamed: "climbergirl1")
                    self.climberState = false
                } else {
                    self.climber.texture = SKTexture(imageNamed: "climbergirl2")
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
        }

    }

    func moveSpider (){

    }

    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        moveClimber()
        scoreLabel.text = String(score / 25)

    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touched = true
        for touch in touches {
            location = touch.location(in: view)
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

    func createPointNode() {
        let pointNode = SKShapeNode(rect: CGRect(x: 0, y: 0, width: 10, height: 10))

        // Physics
        pointNode.physicsBody = SKPhysicsBody(rectangleOf: pointNode.frame.size)
        pointNode.physicsBody?.usesPreciseCollisionDetection = true
        pointNode.physicsBody?.isDynamic = false
        pointNode.physicsBody?.affectedByGravity = false
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

    func pointHit(climber: SKSpriteNode, object: SKNode) {
        if object is SKShapeNode {
            score += 500
            object.removeFromParent()
            pointNodes.remove(at: pointNodes.index(of: object as! SKShapeNode)!)
            createPointNode()
        }
    }

    func spiderHit(climber: SKSpriteNode, spider: SKSpriteNode) {
        if !self.children.contains(endGameLabel) {
            addChild(endGameLabel)
            gameOver = true
            climber.physicsBody?.affectedByGravity = true
            climber.physicsBody?.applyImpulse(CGVector(dx: 35, dy: 250))
        }
    }

    func moveBackground(direction: Direction, speed: CGFloat) {
        movePointNodes()
        score += 1
        background.position = CGPoint(x: self.frame.size.width / 2, y: background.position.y - speed)
        if background.frame.maxY <= 0 {
            background.position = CGPoint(x: self.frame.size.width / 2, y: view!.frame.size.height * 1.5)
        }
        background2.position = CGPoint(x: self.frame.size.width / 2, y: background2.position.y - speed)
        if background2.frame.maxY <= 0 {
            background2.position = CGPoint(x: self.frame.size.width / 2, y: view!.frame.size.height * 1.5)
        }
    }

    func rand(withMultiplier multiplier: Double) -> Double {
        return drand48() * multiplier
    }
}
