//
//  ScoreData.swift
//  SendIt
//
//  Created by gomeow on 5/8/18.
//  Copyright © 2018 Davis and Jesenia Inc. All rights reserved.

import UIKit

class ScoreData : CustomStringConvertible {
    let dateFormatter: DateFormatter = DateFormatter()

    var username: String
    var score: Int
    var date: Date

    init(username: String, score: Int, date: Date) {
        self.username = username
        self.score = score
        self.date = date
        self.dateFormatter.dateFormat = "yyyy-MM-dd"
    }

    var description: String {
        return self.dateFormatter.string(from: self.date) + " " + self.username + " " + String(self.score)
    }

}
