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

    private let endpoint: URL
    private let session: URLSessionType
    private var tasks: [URLSessionDataTaskType] = []
    private var cache: [ArticleKey:Article] = [:]

    private let image = URL(string: "https://s18.postimg.org/h3701xrex/lstn_article_image_placeholder_2.png")!

    private enum AudioFormat: String {
        case wav = "audio/wav"
        case hls = "application/x-mpegurl"
        case mp3 = "audio/mpeg"
    }

    // TODO: Inject authentication token as well as endpoint; test

    init(endpoint: URL = Lstn.endpoint, session: URLSessionType = URLSession.shared) {

        self.endpoint = endpoint
        self.session = session

    }

    func resolve(key: ArticleKey) {

        self.delegate?.resolutionDidStart(key: key)

        let request = self.request(for: key)

        let task = self.session.dataTask(with: request) { data, response, error in

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

            self.tasks = self.tasks.filter({ $0.state != .completed })
            
//                .enumerated()
//                .filter({ $0.element.state == .completed })
//                .map({ $0.offset })
//                .forEach({ self.tasks.remove(at: $0) })

        }

        self.tasks.append(task)
        task.resume()

    }

    private func articleFromJson(json: Any) -> Article? {

        guard let dictionary = json as? [String:Any] else {
            return nil
        }

        guard let state = dictionary["state"] as? String, state == "processed" else {
            return nil
        }

        guard let id = dictionary["id"] as? String else {
            return nil
        }

        // guard let publisher = dictionary["publisher"] as? [String:Any] else {
        //     return nil
        // }

        // guard let publisherId = publisher["id"] as? String else {
        //     return nil
        // }

        // guard let publisherName = publisher["name"] as? String else {
        //     return nil
        // }

        guard let source = URL(string: dictionary["url"] as? String) else {
            return nil
        }

        guard let media = dictionary["media"] as? [[String:Any]] else {
            return nil
        }

        guard let audio = self.audio(for: media) else {
            return nil
        }

        // let image = URL(string: dictionary["image"] as? String) ?? self.image

        guard let title = dictionary["title"] as? String else {
            return nil
        }

        // guard let author = dictionary["author"] as? String else {
        //     return nil
        // }

        // Temporary hard-coded values
        // TODO: Swap out once API implementation is complete

        let publisher = "Lstn"
        let author = dictionary["author"] as? String ?? "Lstn"

        let key = ArticleKey(id: id, source: "unknown", publisher: "unknown")

        let article = Article(key: key, source: source, audio: audio, image: self.image,
                              title: title, author: author, publisher: publisher)

        return article

    }

    func url(for key: ArticleKey) -> URL {
        return self.endpoint.appendingPathComponent("/news_sites/\(key.source)/articles/\(key.id)")
    }

    func request(for key: ArticleKey) -> URLRequest {

        var request = URLRequest(url: self.url(for: key))
        let token = Lstn.token ?? ""

        request.setValue("Token token=\(token)", forHTTPHeaderField: "Authorization")
        return request

    }

    func audio(for media: [[String:Any]]) -> URL? {

        let candidates = media.filter { ($0["role"] as? String)?.lowercased() == "summary" }

        let wav = candidates.filter { ($0["content_type"] as? String)?.lowercased() == AudioFormat.wav.rawValue }
        let hls = candidates.filter { ($0["content_type"] as? String)?.lowercased() == AudioFormat.hls.rawValue }
        let mp3 = candidates.filter { ($0["content_type"] as? String)?.lowercased() == AudioFormat.mp3.rawValue }

        guard let item = hls.first ?? mp3.first ?? wav.first else {
            return nil
        }

        guard let url = item["url"] as? String else {
            return nil
        }

        return URL(string: url)

    }

}
