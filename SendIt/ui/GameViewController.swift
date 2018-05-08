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

    override func viewDidLoad() {
        super.viewDidLoad()


        NetworkManager.getTopScores() {
            (result: [ScoreData]?) in
            if result != nil {
                print(result!)
            }
        }
    }

    @IBAction func startGame(_ sender: UIButton) {
        let scene = GameScene (size: view.bounds.size)
        let skView = view as! SKView
        skView.presentScene(scene)
    }

    @IBAction func showTopScores(_ sender: UIButton) {
        let vc = TopScoresTableViewController()
        self.present(vc, animated: true, completion: nil)
    }


    override var prefersStatusBarHidden: Bool {
        return true
    }


}
