//
//  CategoryViewController.swift
//  AppveloxTest
//
//  Created by Gamid on 09.07.2020.
//  Copyright © 2020 Gamid. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var selectedCategory: String?
    
    var categories: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func cancelButton() {
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let newsVC = segue.destination as? NewsFeedTableViewController {
            newsVC.selectedCategory = selectedCategory
        }
    }
    
}


extension CategoryViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as? CategoryTableViewCell else { return UITableViewCell() }
        
        let category = categories[indexPath.item]
        cell.category = category
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCategory = categories[indexPath.item]
        performSegue(withIdentifier: "unwindToNewsFeedSegue", sender: nil)
    }
    
}
