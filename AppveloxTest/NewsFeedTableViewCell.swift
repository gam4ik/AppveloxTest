//
//  NewsFeedTableViewCell.swift
//  AppveloxTest
//
//  Created by Gamid on 11.06.2020.
//  Copyright © 2020 Gamid. All rights reserved.
//

import UIKit

class NewsFeedTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    var item: RSSItem! {
        didSet {
            titleLabel.text = item.title
            dateLabel.text = item.pubDate
        }
    }
    
}
