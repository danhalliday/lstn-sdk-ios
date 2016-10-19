//
//  ArticlesController.swift
//  Lstn
//
//  Created by Dan Halliday on 10/13/2016.
//  Copyright (c) 2016 Dan Halliday. All rights reserved.
//

import UIKit
import Lstn

class ArticlesController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    let articles = [
        [
            "title": "Pentonville Prison stabbing: Inmate killed and two injured",
            "url": "http://www.bbc.co.uk/news/uk-england-london-37698780"
        ],
        [
            "title": "Mosul battle: 900 civilians flee city ahead of fighting",
            "url": "http://www.bbc.co.uk/news/world-middle-east-37701235"
        ],
        [
            "title": "A photo of an orangutan climbing high into a tree",
            "url": "http://www.bbc.co.uk/news/science-environment-37693214"
        ],
        [
            "title": "A Conservative MP who wants child migrants arriving in the UK",
            "url": "http://www.bbc.co.uk/news/uk-37700074"
        ],
        [
            "title": "The UK's biggest builders merchant says it is closing 30 branches",
            "url": "http://www.bbc.co.uk/news/business-37701427"
        ]
    ]

    override func viewDidLoad() {

        super.viewDidLoad()

        self.tableView.dataSource = self
        self.tableView.delegate = self

    }

}

// MARK: - Table View Data Source

extension ArticlesController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? self.articles.count : 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "articleCell", for: indexPath)
        let article = self.articles[indexPath.row]

        cell.textLabel?.text = article["title"]!
        cell.detailTextLabel?.text = article["url"]!
        cell.detailTextLabel?.alpha = 0.25

        return cell

    }

}

// MARK: - Table View Delegate

extension ArticlesController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let article = self.articles[indexPath.row]
        let url = URL(string: article["url"]!)!

        Lstn.shared.player.load(source: url) { success in
            if success { Lstn.shared.player.play() }
        }

    }

}
