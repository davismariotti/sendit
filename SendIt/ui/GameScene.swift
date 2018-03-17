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
    var ball: SKShapeNode = SKShapeNode(circleOfRadius: 15)
    var background: SKSpriteNode = SKSpriteNode(imageNamed: "background")

    override func didMove(to view: SKView) {
        background.size = frame.size
        background.position = CGPoint(x: view.frame.size.width / 2, y: view.frame.size.height / 2)
        addChild(background)

        let path = CGMutablePath()
        path.addArc(center: CGPoint.zero,
                    radius: 15,
                    startAngle: 0,
                    endAngle: CGFloat.pi * 2,
                    clockwise: false)
        ball = SKShapeNode(path: path)
        ball.position = CGPoint(x: view.frame.size.width / 2, y: view.frame.size.height / 2)
        ball.lineWidth = 1
        ball.fillColor = .cyan
        ball.strokeColor = .cyan
        ball.glowWidth = 0.5
        addChild(ball)
        print(ball.position)
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
            let speed: CGFloat = (location.x - ball.position.x) / 20
            let newLocation = ball.position.x + speed
            ball.position = CGPoint(x: newLocation, y: ball.position.y)
        }
    }
}
