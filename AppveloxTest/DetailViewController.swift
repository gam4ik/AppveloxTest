//
//  DetailViewController.swift
//  AppveloxTest
//
//  Created by Gamid on 11.06.2020.
//  Copyright © 2020 Gamid. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    
    var item: RSSItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let item = item else { print("Error with item in detail"); return }
        setImage(url: item.image)
        setTitle(title: item.title)
        setText(text: item.text)
    }

    @IBAction func backButtonTouched(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    private func setImage(url: String) {
        if url == "" {
            imageView.isHidden = true
            imageView.heightAnchor.constraint(equalToConstant: 0).isActive = true
        } else {
            imageView.isHidden = false
            imageView.heightAnchor.constraint(equalToConstant: 170).isActive = true
            getImage(url: url)
        }
    }
    
    private func setTitle(title: String) {
        titleLabel.text = title
    }
    
    private func setText(text: String) {
        textLabel.text = text
    }
    
    private func getImage(url: String) {
        guard let url = URL(string: url) else { print("Error with image url"); return }
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url)
            DispatchQueue.main.async {
                self.imageView.image = UIImage(data: data!)
            }
        }
    }
    
}
