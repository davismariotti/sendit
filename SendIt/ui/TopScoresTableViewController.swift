//
//  TopScoresTableViewController.swift
//  SendIt
//
//  Created by gomeow on 5/8/18.
//  Copyright © 2018 Davis and Jesenia Inc. All rights reserved.
//

import UIKit

class TopScoresTableViewController: UITableViewController {

    var scoreDatas: [ScoreData] = []

    override func viewDidLoad() {
        super.viewDidLoad()

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

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scoreDatas.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "kTopScoreTableViewCellIdentifier", for: indexPath) as! TopScoreTableViewCell
        let scoreData = scoreDatas[indexPath.row]
        print(scoreData.username)
        cell.username.text = scoreData.username
        cell.score.text = String(scoreData.score)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        cell.date.text = dateFormatter.string(from: scoreData.date)
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}
