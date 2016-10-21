//
//  RemoteContentResolver.swift
//  Pods
//
//  Created by Dan Halliday on 18/10/2016.
//
//

import Foundation

class RemoteContentResolver: ContentResolver {

    private let session: URLSessionType
    private var task: URLSessionDataTaskType?

    private let queue = DispatchQueue(label: "Lstn Content Resolver")

    init(session: URLSessionType = URLSession.shared) {
        self.session = session
    }

    func resolve(source: URL, callback: ((ContentResolverState) -> Void)? = nil) {

         self.queue.async {

            callback?(.started)
            self.task?.cancel()

            let task = self.session.dataTask(with: self.url(source: source)) {
                data, response, error in
                self.queue.async {
                    callback?(self.handler(data: data, response: response, error: error))
                }
            }

            self.task = task
            task.resume()

        }

    }

    private func handler(data: Data?, response: URLResponse?, error: Error?) -> ContentResolverState {

        if let error = error as? NSError {
            return (error.code == -999 && error.domain == NSURLErrorDomain) ? .cancelled : .failed
        }

        guard let response = response as? HTTPURLResponse else {
            return .failed
        }

        if response.statusCode != 200 {
            // TODO: handle retry if status == 202
            return .failed
        }

        guard let data = data else {
            return .failed
        }

        if data.count == 0 {
            return .failed
        }

        let json: Any

        do { json = try JSONSerialization.jsonObject(with: data) } catch {
            return .failed
        }

        guard let dictionary = json as? [String:Any] else {
            return .failed
        }

        guard let content = Content(dictionary: dictionary) else {
            return .failed
        }

        return .resolved(content)

    }

    private func url(source: URL) -> URL {
        return URL(string: "\(Lstn.API)/content/?source=\(self.escape(url: source))")!
    }

    private func escape(url: URL) -> String {
        return url.absoluteString.addingPercentEncoding(withAllowedCharacters: .urlUserAllowed)!
    }

}
