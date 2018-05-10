//
//  GameViewController.swift
//  SendIt
//
//  Created by gomeow on 3/12/18.
//  Copyright © 2018 Davis and Jesenia Inc. All rights reserved.
//

import UIKit
import SpriteKit
import PureLayout

class GameViewController: UIViewController {
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var topScoreButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func startGame(_ sender: UIButton) {
        let scene = GameScene (size: view.bounds.size)
        let skView = view as! SKView
        skView.presentScene(scene)
        startButton.isHidden = true
        topScoreButton.isHidden = true
    }

    @IBAction func showTopScores(_ sender: UIButton) {
        let vc = TopScoreViewController()
        self.navigationController!.pushViewController(vc, animated: true)
    }


    override var prefersStatusBarHidden: Bool {
        return true
    }


}
