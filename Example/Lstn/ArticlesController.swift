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

    let store = ArticleStore()
    var articles: [Article] = []

    let publisher = ProcessInfo.processInfo.environment["LSTN_EXAMPLE_PUBLISHER"]!

    override func viewDidLoad() {

        super.viewDidLoad()

        self.tableView.dataSource = self
        self.tableView.delegate = self

        self.navigationItem.prompt = "Loading articles..."

        self.store.fetch { articles in
            DispatchQueue.main.async { self.loadingDidFinish(articles: articles) }
        }

    }

    func loadingDidFinish(articles: [Article]?) {

        guard let articles = articles else {
            self.navigationItem.prompt = "Failed to fetch articles!"
            return
        }

        self.articles = articles
        self.navigationItem.prompt = nil

        self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)

    }

    func titleForRow(index: Int) -> String {
        return self.articles[index].title
    }

    func detailForRow(index: Int) -> String {
        return self.articles[index].summary
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

        let article = self.articles[indexPath.row]
        
        Lstn.shared.player.load(article: article.id, publisher: self.publisher) {
            success in if success { Lstn.shared.player.play() }
        }

    }

}
