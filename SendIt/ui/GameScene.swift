//
//  GameScene.swift
//  SendIt
//
//  Created by gomeow on 3/12/18.
//  Copyright © 2018 Davis and Jesenia Inc. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {

    var touched = false
    var location = CGPoint.zero
    var background: SKSpriteNode = SKSpriteNode(imageNamed: "background")
    var background2: SKSpriteNode = SKSpriteNode(imageNamed: "background")
    var climber: SKSpriteNode = SKSpriteNode(imageNamed: "climbergirl1")

    override func didMove(to view: SKView) {
        background.size = frame.size
        background.position = CGPoint(x: view.frame.size.width / 2, y: view.frame.size.height / 2)
        addChild(background)
        background2.size = frame.size
        background2.position = CGPoint(x: view.frame.size.width / 2, y: view.frame.size.height * 1.5)
        addChild(background2)


        climber.position = CGPoint(x: view.frame.size.width / 2, y: view.frame.size.height / 2)
        addChild(climber)
    }


    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        moveNode()
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

    func moveNode() {
        if touched {
            // First move horizontally
            let speed: CGFloat = (location.x - climber.position.x) / 20
            let newLocation = climber.position.x + speed
            climber.position = CGPoint(x: newLocation, y: climber.position.y)
            // then vertically
            if (view!.frame.size.height - location.y) > view!.frame.size.height / 2 {
                if climber.position.y < view!.frame.size.height - 50 {
                    climber.position = CGPoint(x: climber.position.x, y: climber.position.y + 4)
                } else {
                    moveBackground()
                }
            } else if (view!.frame.size.height - location.y) < view!.frame.size.height / 2 && climber.position.y > 50 {
                climber.position = CGPoint(x: climber.position.x, y: climber.position.y - 4)
            }
        }
    }

    func moveBackground() {
        background.position = CGPoint(x: background.position.x, y: background.position.y - 4)
        if background.frame.maxY <= 0 {
            background.position = CGPoint(x: background.position.x, y: view!.frame.size.height * 1.5)
        }
        background2.position = CGPoint(x: background2.position.x, y: background2.position.y - 4)
        if background2.frame.maxY <= 0 {
            background2.position = CGPoint(x: background2.position.x, y: view!.frame.size.height * 1.5)
        }
    }
}
