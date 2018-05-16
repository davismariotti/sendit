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
    @IBOutlet weak var optionsButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.init(patternImage: UIImage(named: "background")!)

        self.titleLabel.font = UIFont(name: "8BITWONDERNominal", size: 56)
        self.titleLabel.textColor = .white

        self.startButton.titleLabel?.font = UIFont(name: "8BITWONDERNominal", size: 20)
        self.startButton.setTitleColor(.white, for: .normal)


        self.topScoreButton.titleLabel?.font = UIFont(name: "8BITWONDERNominal", size: 15)
        self.topScoreButton.setTitleColor(.white, for: .normal)

        self.optionsButton.titleLabel?.font = UIFont(name: "8BITWONDERNominal", size: 15)
        self.optionsButton.setTitleColor(.white, for: .normal)


        // Check if the user has a username
        let defaults = UserDefaults.standard
        let username = defaults.string(forKey: "username")
        if username == nil {
            let alert = UIAlertController(title: "Enter username", message: "", preferredStyle: .alert)
            alert.addTextField() { (textField) in
                textField.placeholder = "Username"
            }

            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {[weak alert] (_) in
                let textField = alert!.textFields![0]
                if let text = textField.text {
                    if text != "" {
                        if text.count < 9 {
                            defaults.set(text, forKey: "username")
                            return
                        } else {
                            alert!.message = "Username must be no longer than 9 characters."
                            self.present(alert!, animated: true, completion: nil)
                            return
                        }
                    }
                    alert!.message = "You must enter a username"
                    self.present(alert!, animated: true, completion: nil)
                }
            }))

            self.present(alert, animated: true, completion: nil)
        }

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

    @IBAction func showOptions(_ sender: UIButton) {
        let vc = OptionViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    func returnToMainMenu() {
        self.navigationController?.popViewController(animated: true)
    }

}
