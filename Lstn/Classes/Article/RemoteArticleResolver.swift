//
//  RemoteArticleResolver.swift
//  Pods
//
//  Created by Dan Halliday on 09/11/2016.
//
//

import Foundation

class RemoteArticleResolver: ArticleResolver {

    weak var delegate: ArticleResolverDelegate? = nil

    private let endpoint: String
    private let session: URLSessionType
    private var tasks: [URLSessionDataTaskType] = []
    private var cache: [ArticleKey:Article] = [:]

    init(endpoint: String = Lstn.endpoint, session: URLSessionType = URLSession.shared) {

        self.endpoint = endpoint
        self.session = session

    }

    func resolve(key: ArticleKey) {

        self.delegate?.resolutionDidStart(key: key)

        let url = URL(string: "\(self.endpoint)/publisher/\(key.publisher)/articles/\(key.id)")!

        // TODO: Authentication token
        
        let task = self.session.dataTask(with: url) { data, response, error in

            if let _ = error as? NSError {
                self.delegate?.resolutionDidFail(key: key)
                return
            }

            guard let response = response as? HTTPURLResponse else {
                self.delegate?.resolutionDidFail(key: key)
                return
            }

            if response.statusCode != 200 {
                self.delegate?.resolutionDidFail(key: key);
                return
            }

            guard let data = data else {
                self.delegate?.resolutionDidFail(key: key)
                return
            }

            if data.count == 0 {
                self.delegate?.resolutionDidFail(key: key)
                return
            }

            let json: Any

            do { json = try JSONSerialization.jsonObject(with: data) } catch {
                self.delegate?.resolutionDidFail(key: key)
                return
            }

            guard let article = self.articleFromJson(json: json) else {
                self.delegate?.resolutionDidFail(key: key)
                return
            }

            self.delegate?.resolutionDidFinish(key: key, article: article)

            self.tasks
                .enumerated()
                .filter({ $0.element.state == .completed })
                .map({ $0.offset })
                .forEach({ self.tasks.remove(at: $0) })

        }

        self.tasks.append(task)
        task.resume()

    }

    private func articleFromJson(json: Any) -> Article? {

        guard let dictionary = json as? [String:Any] else {
            return nil
        }

        guard let id = dictionary["id"] as? String else {
            return nil
        }

        guard let publisher = dictionary["publisher"] as? [String:Any] else {
            return nil
        }

        guard let publisherId = publisher["id"] as? String else {
            return nil
        }

        guard let publisherName = publisher["name"] as? String else {
            return nil
        }

        guard let source = URL(string: dictionary["url"] as? String) else {
            return nil
        }

        guard let media = dictionary["media"] as? [[String:Any]] else {
            return nil
        }

        guard let audio = URL(string: media.first?["url"] as? String) else {
            return nil
        }

        guard let image = URL(string: dictionary["image"] as? String) else {
            return nil
        }

        guard let title = dictionary["title"] as? String else {
            return nil
        }

        guard let author = dictionary["author"] as? String else {
            return nil
        }

        let key = ArticleKey(id: id, publisher: publisherId)

        let article = Article(key: key, source: source, audio: audio, image: image,
                              title: title, author: author, publisher: publisherName)

        return article

    }

}
