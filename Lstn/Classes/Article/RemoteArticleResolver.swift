//
//  RemoteArticleResolver.swift
//  Pods
//
//  Created by Dan Halliday on 09/11/2016.
//
//

import Foundation

public class RemoteArticleResolver: ArticleResolver {

    public weak var delegate: ArticleResolverDelegate? = nil

    private let endpoint: URL
    private let session: URLSessionType
    private var tasks: [URLSessionDataTaskType] = []
    private var cache: [ArticleKey:Article] = [:]

    init(endpoint: URL = Lstn.API, session: URLSessionType = URLSession.shared) {

        self.endpoint = endpoint
        self.session = session

    }

    public func resolve(key: ArticleKey) {

        self.delegate?.resolutionDidStart(key: key)

        let url = self.endpoint
            .appendingPathComponent("/publisher/\(key.publisher)/articles/\(key.id)/")

        let task = self.session.dataTask(with: url) { data, response, error in

            if let error = error as? NSError {

            }

            guard let response = response as? HTTPURLResponse else {
                self.delegate?.resolutionDidFail(key: key)
                return
            }

            if response.statusCode != 200 {
                self.delegate?.resolutionDidFail(key: key)
                return
            }

            self.tasks.enumerated().reduce([], { (completed, current) -> [Int] in
                return current.1.state == .completed ? completed + [current.0] : completed
            }).forEach({ self.tasks.remove(at: $0) })

        }

        self.tasks.append(task)
        task.resume()

    }

}
