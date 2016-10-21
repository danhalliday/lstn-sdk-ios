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

    func titleForRow(index: Int) -> String {
        return self.articles[index]["title"]!
    }

    func detailForRow(index: Int) -> String {
        return self.articles[index]["url"]!
    }

    func urlForRow(index: Int) -> URL {
        return URL(string: self.articles[index]["url"]!)!
    }

}

// MARK: - Table View Data Source

extension ArticlesController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.articles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "articleCell", for: indexPath)

        cell.textLabel?.text = self.titleForRow(index: indexPath.row)
        cell.detailTextLabel?.text = self.detailForRow(index: indexPath.row)

        return cell

    }

}

// MARK: - Table View Delegate

extension ArticlesController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let url = self.urlForRow(index: indexPath.row)

        Lstn.shared.player.load(source: url) { success in
            if success { Lstn.shared.player.play() }
        }

    }

}
