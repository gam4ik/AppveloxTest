//
//  FeedParser.swift
//  AppveloxTest
//
//  Created by Gamid on 11.06.2020.
//  Copyright © 2020 Gamid. All rights reserved.
//

import Foundation

struct RSSItem {
    let category: String
    let title: String
    let pubDate: String
    let text: String
    let image: String
}

class FeedParser: NSObject, XMLParserDelegate {
    private var rssItems: [RSSItem] = []
    private var currentElement = ""
    
    private var currentCategory = "" {
        didSet {
            currentCategory = currentCategory.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    private var currentTitle = "" {
        didSet {
            currentTitle = currentTitle.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    private var currentPubDate = "" {
        didSet {
            currentPubDate = currentPubDate.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    private var currentText = "" {
        didSet {
            currentText = currentText.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    private var currentImage = ""
    
    private var parserCompletionHandler: (([RSSItem]) -> ())?
    
    func parseFeed(url: String, completionHandler: (([RSSItem]) -> ())?) {
        parserCompletionHandler = completionHandler
        
        let request = URLRequest(url: URL(string: url)!)
        let urlSession = URLSession.shared
        let task = urlSession.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                if let error = error {
                    print(error.localizedDescription)
                }
                return
            }
            let parser = XMLParser(data: data)
            parser.delegate = self
            parser.parse()
        }
        task.resume()
    }
    
    //MARK: - XMLParserDelegate
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        if currentElement == "item" {
            currentCategory = ""
            currentTitle = ""
            currentText = ""
            currentPubDate = ""
            currentImage = ""
        }
        if currentElement == "enclosure" {
            if let url = attributeDict["url"] {
                currentImage = url
            }
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch currentElement {
        case "title": currentTitle += string
        case "pubDate": currentPubDate += string
        case "category": currentCategory += string
        case "yandex:full-text": currentText += string
        default: break
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            let rssItem = RSSItem(category: currentCategory, title: currentTitle, pubDate: currentPubDate, text: currentText, image: currentImage)
            rssItems.append(rssItem)
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        parserCompletionHandler?(rssItems)
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print(parseError.localizedDescription)
    }
}
