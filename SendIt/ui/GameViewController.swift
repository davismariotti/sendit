//
//  GameViewController.swift
//  SendIt
//
//  Created by gomeow on 5/9/18.
//  Copyright © 2018 Davis and Jesenia Inc. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    var gameDelegate: GameSceneDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        let scene = GameScene(size: view.bounds.size)
        scene.gameDelegate = gameDelegate
        let skView = view as! SKView
        skView.presentScene(scene)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}
