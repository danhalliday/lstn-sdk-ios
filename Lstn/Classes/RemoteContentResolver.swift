//
//  RemoteContentResolver.swift
//  Pods
//
//  Created by Dan Halliday on 18/10/2016.
//
//

import Foundation

class RemoteContentResolver: ContentResolver {

    private let endpoint = "https://api.lstn.ltd/articles"

    private let session: URLSessionType
    private var task: URLSessionDataTaskType?

    init(session: URLSessionType = URLSession.shared) {
        self.session = session
    }

    func resolve(source: URL, callback: ((ContentResolverState) -> Void)? = nil) {

        callback?(.started)
        self.task?.cancel()

        let task = self.session.dataTask(with: self.url(source: source)) {
            callback?(self.handler(data: $0, response: $1, error: $2))
        }

        self.task = task
        task.resume()

    }

    private func handler(data: Data?, response: URLResponse?, error: Error?) -> ContentResolverState {

        if let error = error {
            return .failed(.unknown(error))
        }

        guard let response = response as? HTTPURLResponse else {
            return .failed(.unknown(nil))
        }

        if response.statusCode != 200 {
            // TODO: handle retry if status == 202
            return .failed(.http(response.statusCode))
        }

        guard let data = data else {
            return .failed(.data(nil))
        }

        if data.count == 0 {
            return .failed(.data(data))
        }

        let json: Any

        do { json = try JSONSerialization.jsonObject(with: data) } catch {
            return .failed(.data(data))
        }

        guard let array = json as? [String] else {
            return .failed(.data(json))
        }

        let result = array.map { URL(string: $0)! }

        return .succeeded(result)

    }

    private func url(source: URL) -> URL {
        return URL(string: "\(self.endpoint)?source=\(self.escape(url: source))")!
    }

    private func escape(url: URL) -> String {
        return url.absoluteString.addingPercentEncoding(withAllowedCharacters: .urlUserAllowed)!
    }

}
