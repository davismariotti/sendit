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

    override func didMove(to view: SKView) {
        let path = CGMutablePath()
        path.addArc(center: CGPoint(x: view.frame.size.width / 2, y: view.frame.size.height / 2),
                    radius: 15,
                    startAngle: 0,
                    endAngle: CGFloat.pi * 2,
                    clockwise: false)
        ball = SKShapeNode(path: path)
        ball.lineWidth = 1
        ball.fillColor = .cyan
        ball.strokeColor = .cyan
        ball.glowWidth = 0.5
        addChild(ball)
    }


    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        moveNode()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touched = true
        for touch in touches {
            location = touch.location(in: self)
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            location = touch.location(in: self)

        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touched = false
    }

    func moveNode() {
        if touched {
            let speed: CGFloat = 1
            if location.x < self.view!.frame.size.width / 4 {
                let newLocation = ball.position.x - speed
                ball.position = CGPoint(x: newLocation, y: ball.position.y)
            } else {
                let newLocation = ball.position.x + speed
                ball.position = CGPoint(x: newLocation, y: ball.position.y)
            }
        }
    }
}
