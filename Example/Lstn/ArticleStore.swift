//
//  ArticleStore.swift
//  Lstn
//
//  Created by Dan Halliday on 14/11/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

class ArticleStore {

    let token = ProcessInfo.processInfo.environment["LSTN_EXAMPLE_TOKEN"]!
    let publisher = ProcessInfo.processInfo.environment["LSTN_EXAMPLE_PUBLISHER"]!
    let endpoint = ProcessInfo.processInfo.environment["LSTN_EXAMPLE_ENDPOINT"]!

    func fetch(complete: @escaping ([Article]?) -> Void) {

        let url = URL(string: "\(self.endpoint)/publishers/\(self.publisher)/articles/")!
        var request = URLRequest(url: url)

        request.setValue("Bearer \(self.token)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in

            if let _ = error {
                complete(nil)
                return
            }

            guard let response = response as? HTTPURLResponse else {
                complete(nil)
                return
            }

            if response.statusCode != 200 {
                complete(nil)
                return
            }

            guard let data = data else {
                complete(nil)
                return
            }

            if data.count == 0 {
                complete(nil)
                return
            }

            let json: Any

            do { json = try JSONSerialization.jsonObject(with: data) } catch {
                complete(nil)
                return
            }

            guard let array = json as? [Any] else {
                complete(nil)
                return
            }

            let articles = array.flatMap { self.articleFromJson(json: $0) }

            if articles.count == 0 {
                complete(nil)
                return
            }

            complete(articles)

        }

        task.resume()

    }

    private func articleFromJson(json: Any) -> Article? {

        guard let dictionary = json as? [String:Any] else {
            return nil
        }

        guard let id = dictionary["id"] as? String else {
            return nil
        }

        guard let title = dictionary["title"] as? String else {
            return nil
        }

        guard let summary = dictionary["summary"] as? String else {
            return nil
        }

        return Article(id: id, title: title, summary: summary)

    }

}
