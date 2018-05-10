//
//  TopScoreViewController.swift
//  SendIt
//
//  Created by gomeow on 5/8/18.
//  Copyright © 2018 Davis and Jesenia Inc. All rights reserved.
//

import UIKit

class TopScoreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topScoreLabel: UILabel!

    var scoreDatas: [ScoreData] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.init(patternImage: UIImage(named: "background")!)

        self.topScoreLabel.font = UIFont(name: "8BITWONDERNominal", size: 20)

        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = UIColor.clear

        self.tableView.register(UINib(nibName: "TopScoreTableViewCell", bundle: nil), forCellReuseIdentifier: "kTopScoreTableViewCellIdentifier")

        NetworkManager.getTopScores() {
            (results: [ScoreData]?) in
            if results != nil {
                self.scoreDatas = results!
                OperationQueue.main.addOperation {
                    self.tableView.reloadData()
                }
            }
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.scoreDatas.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "kTopScoreTableViewCellIdentifier", for: indexPath) as! TopScoreTableViewCell
        let scoreData = scoreDatas[indexPath.row]
        print(scoreData.username)
        cell.username.text = scoreData.username
        cell.score.text = String(scoreData.score)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
//        cell.date.text = dateFormatter.string(from: scoreData.date)
        return cell
    }

    func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        return false
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
        cell.contentView.backgroundColor = UIColor.clear
    }

}
