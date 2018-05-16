//
//  OptionViewController.swift
//  SendIt
//
//  Created by gomeow on 5/16/18.
//  Copyright © 2018 Davis and Jesenia Inc. All rights reserved.
//

import UIKit
import PureLayout

class OptionViewController: UIViewController {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var chooseLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var choosenUsernameLabel: UILabel!
    @IBOutlet weak var editUsernameButton: UIButton!

    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var boyImageView: UIImageView!
    @IBOutlet weak var girlImageView: UIImageView!

    let borderView: UIView! = UIView()
    var borderConstraints: [NSLayoutConstraint] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        self.chooseLabel.font = UIFont(name: "8BITWONDERNominal", size: 20)
        self.chooseLabel.textColor = .white
        self.usernameLabel.font = UIFont(name: "8BITWONDERNominal", size: 20)
        self.usernameLabel.textColor = .white
        self.choosenUsernameLabel.font = UIFont(name: "8BITWONDERNominal", size: 20)
        self.choosenUsernameLabel.textColor = .white

        self.choosenUsernameLabel.text = UserDefaults.standard.string(forKey: "username")

        self.view.backgroundColor = UIColor.init(patternImage: UIImage(named: "background")!)


        self.backButton.titleLabel?.font = UIFont(name: "8BITWONDERNominal", size: 16)
        self.backButton.setTitleColor(.white, for: .normal)

        var choosen = UserDefaults.standard.string(forKey: "character")
        if choosen == nil {
            choosen = "girl"
        }

        self.borderView.layer.borderColor = UIColor.white.cgColor
        self.borderView.layer.borderWidth = 5
        self.borderView.layer.cornerRadius = 10
        self.borderView.backgroundColor = .clear
        self.view.addSubview(self.borderView)

        let choosenView = choosen == "boy" ? self.boyImageView : self.girlImageView

        self.addBorderConstraints(toView: choosenView!, shouldRemoveOldConstraints: false)


        let boyRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.chooseBoy))
        self.boyImageView.addGestureRecognizer(boyRecognizer)
        self.boyImageView.isUserInteractionEnabled = true

        let girlRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.chooseGirl))
        self.girlImageView.addGestureRecognizer(girlRecognizer)
        self.girlImageView.isUserInteractionEnabled = true

        self.editUsernameButton.titleLabel?.font = UIFont(name: "8BITWONDERNominal", size: 16)
        self.editUsernameButton.setTitleColor(.white, for: .normal)

    }

    func addBorderConstraints(toView choosenView: UIView, shouldRemoveOldConstraints remove: Bool) {
        if remove {
            for constraint in self.borderConstraints {
                constraint.autoRemove()
            }
        }
        self.borderConstraints = NSLayoutConstraint.autoCreateAndInstallConstraints {
            self.borderView.autoPinEdge(.top, to: .top, of: choosenView, withOffset: -10)
            self.borderView.autoPinEdge(.bottom, to: .bottom, of: choosenView, withOffset: 10)
            self.borderView.autoPinEdge(.left, to: .left, of: choosenView, withOffset: -10)
            self.borderView.autoPinEdge(.right, to: .right, of: choosenView, withOffset: 10)
        }
        self.view.layoutIfNeeded()
    }

    @objc func chooseBoy() {
        UIView.animate(withDuration: 0.7) {
            self.addBorderConstraints(toView: self.boyImageView, shouldRemoveOldConstraints: true)
        }
        UserDefaults.standard.set("boy", forKey: "character")
    }

    @objc func chooseGirl() {
        UIView.animate(withDuration: 0.7) {
            self.addBorderConstraints(toView: self.girlImageView, shouldRemoveOldConstraints: true)
        }
        UserDefaults.standard.set("girl", forKey: "character")
    }

    @IBAction func editUsername(_ sender: UIButton) {
        let alert = UIAlertController(title: "Enter username", message: "", preferredStyle: .alert)
        alert.addTextField() { (textField) in
            textField.placeholder = "Username"
            textField.returnKeyType = .done
        }

        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: {[weak alert] (_) in
            let textField = alert!.textFields![0]
            if let text = textField.text {
                if text != "" {
                    if text.count < 9 {
                        UserDefaults.standard.set(text, forKey: "username")
                        self.choosenUsernameLabel.text = text
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


    @IBAction func goBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
