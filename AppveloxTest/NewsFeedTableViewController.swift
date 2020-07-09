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
    private var rssItemsWithCategory: [RSSItem]?
    private var selectedItem: RSSItem?
    private var categories: [String] = []
    
    var selectedCategory: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: "Updating...")
        refreshControl?.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        
        fetchData()
    }

    @objc func refresh() {
        fetchData()
        refreshControl?.endRefreshing()
    }
    
    private func fetchData() {
        let feedParser = FeedParser()
        feedParser.parseFeed(url: "http://www.vesti.ru/vesti.rss") { (rssItems) in
            self.rssItems = rssItems
            self.rssItemsWithCategory = rssItems
            self.getCategoriesList()
            self.categorizeRSSItems()
            OperationQueue.main.addOperation {
                self.tableView.reloadSections(IndexSet(integer: 0), with: .left)
            }
        }
    }
    
    private func getCategoriesList() {
        if let rssItems = rssItems {
            rssItems.forEach { (item) in
                let category = item.category
                self.categories.append(category)
            }
            categories = Array(Set(categories))
        }
    }
    
    private func categorizeRSSItems() {
        if let rssItems = rssItems {
            if let category = selectedCategory {
                var categorizeRSSItems: [RSSItem] = []
                rssItems.forEach { (item) in
                    if item.category == category {
                        categorizeRSSItems.append(item)
                    }
                }
                self.rssItemsWithCategory = categorizeRSSItems
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navVC = segue.destination as? UINavigationController {
            if let detailVC = navVC.topViewController as? DetailViewController {
                detailVC.item = selectedItem
            }
        }
        
        if let categoryVC = segue.destination as? CategoryViewController {
            categoryVC.categories = self.categories
        }
    }
    
    @IBAction func showCategories(_ sender: Any) {
        performSegue(withIdentifier: "categorySegue", sender: nil)
    }
    
    @IBAction func unwindToNewsFeed(_ segue: UIStoryboardSegue) {
        categorizeRSSItems()
        OperationQueue.main.addOperation {
            self.tableView.reloadSections(IndexSet(integer: 0), with: .left)
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
        guard let rssItems = rssItemsWithCategory else { return 0 }
        return rssItems.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "newsFeedCell", for: indexPath) as? NewsFeedTableViewCell else { return UITableViewCell() }
        if let item = rssItemsWithCategory?[indexPath.item] {
            cell.item = item
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = rssItemsWithCategory?[indexPath.item] {
            selectedItem = item
            performSegue(withIdentifier: "detailSegue", sender: nil)
        }
    }
    
}
