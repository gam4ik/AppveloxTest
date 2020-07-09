//
//  CategoryTableViewCell.swift
//  AppveloxTest
//
//  Created by Gamid on 09.07.2020.
//  Copyright © 2020 Gamid. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {

    @IBOutlet weak var categoryLabel: UILabel!
    
    var category: String! {
        didSet {
            categoryLabel.text = category
        }
    }
}
