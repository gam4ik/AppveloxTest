//
//  NewsFeedTableViewController.swift
//  AppveloxTest
//
//  Created by Gamid on 10.06.2020.
//  Copyright © 2020 Gamid. All rights reserved.
//

import UIKit

class NewsFeedTableViewController: UITableViewController {

    private var rssItems: [RSSItem]?
    private var selectedItem: RSSItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
    }

    private func fetchData() {
        let feedParser = FeedParser()
        feedParser.parseFeed(url: "http://www.vesti.ru/vesti.rss") { (rssItems) in
            self.rssItems = rssItems
            OperationQueue.main.addOperation {
                self.tableView.reloadSections(IndexSet(integer: 0), with: .right)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navVC = segue.destination as? UINavigationController {
            if let detailVC = navVC.topViewController as? DetailViewController {
                detailVC.item = selectedItem
            }
        }
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let rssItems = rssItems else { return 0 }
        return rssItems.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "newsFeedCell", for: indexPath) as? NewsFeedTableViewCell else { return UITableViewCell() }
        if let item = rssItems?[indexPath.item] {
            cell.item = item
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = rssItems?[indexPath.item] {
            selectedItem = item
            performSegue(withIdentifier: "detailSegue", sender: nil)
        }
    }
    
}
