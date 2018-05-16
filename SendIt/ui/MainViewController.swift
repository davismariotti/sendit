//
//  MainViewController.swift
//  SendIt
//
//  Created by gomeow on 3/12/18.
//  Copyright © 2018 Davis and Jesenia Inc. All rights reserved.
//

import UIKit
import SpriteKit
import PureLayout

class MainViewController: UIViewController, GameSceneDelegate {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var topScoreButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.init(patternImage: UIImage(named: "background")!)

        self.titleLabel.font = UIFont(name: "8BITWONDERNominal", size: 56)
        self.titleLabel.textColor = .white

        self.startButton.titleLabel?.font = UIFont(name: "8BITWONDERNominal", size: 20)
        self.startButton.setTitleColor(.white, for: .normal)


        self.topScoreButton.titleLabel?.font = UIFont(name: "8BITWONDERNominal", size: 15)
        self.topScoreButton.setTitleColor(.white, for: .normal)

    }

    @IBAction func startGame(_ sender: UIButton) {
        let vc = GameViewController()
        vc.gameDelegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func showTopScores(_ sender: UIButton) {
        let vc = TopScoreViewController()
        self.navigationController?.pushViewController(vc, animated: true)

    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    func returnToMainMenu() {
        self.navigationController?.popViewController(animated: true)
    }

}
