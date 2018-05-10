//
//  TopScoreTableViewCell.swift
//  SendIt
//
//  Created by gomeow on 5/8/18.
//  Copyright © 2018 Davis and Jesenia Inc. All rights reserved.
//

import UIKit

class TopScoreTableViewCell: UITableViewCell {

    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var username: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        score.font = UIFont(name: "8BITWONDERNominal", size: 20)
        username.font = UIFont(name: "8BITWONDERNominal", size: 20)
        score.textColor = UIColor.white
        username.textColor = UIColor.white
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
