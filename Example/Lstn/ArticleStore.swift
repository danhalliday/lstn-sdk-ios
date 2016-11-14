//
//  ArticleStore.swift
//  Lstn
//
//  Created by Dan Halliday on 14/11/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

class ArticleStore {

    let publisher = "news-api"
    let endpoint = ProcessInfo.processInfo.environment["LSTN_API_ENDPOINT"]!

    func fetch(complete: @escaping ([Article]?) -> Void) {

        let url = URL(string: "\(self.endpoint)/publisher/\(self.publisher)/articles/")!

        // TODO: Authentication token

        let task = URLSession.shared.dataTask(with: url) { data, response, error in

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

        guard let id = dictionary["id"] as? String else { return nil }

        guard let publisher = dictionary["publisher"] as? [String:Any] else {
            return nil
        }

        guard let publisherId = publisher["id"] as? String else {
            return nil
        }

        guard let title = dictionary["title"] as? String else {
            return nil
        }

        guard let body = dictionary["body"] as? String else {
            return nil
        }

        return Article(id: id, publisher: publisherId, title: title, body: body)

    }

}
