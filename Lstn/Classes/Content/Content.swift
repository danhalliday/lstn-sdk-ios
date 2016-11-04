//
//  Content.swift
//  Pods
//
//  Created by Dan Halliday on 18/10/2016.
//
//

import Foundation

public struct Content {

    let url: URL
    let title: String
    let author: String
    let summary: String
    let body: String
    let publishedAt: String
    let media: [Media]

    struct Media {
        let url: URL
        let type: String
        let role: String
    }

}

extension Content {

    init?(dictionary: [String:Any]?) {

        guard let dictionary = dictionary else {
            return nil
        }

        guard let url = URL(string: dictionary["url"] as? String) else {
            return nil
        }

        guard let title = dictionary["title"] as? String else {
            return nil
        }

        guard let author = dictionary["author"] as? String else {
            return nil
        }

        guard let summary = dictionary["summary"] as? String else {
            return nil
        }

        guard let body = dictionary["body"] as? String else {
            return nil
        }

        guard let publishedAt = dictionary["published_at"] as? String else {
            return nil
        }

        let mediaObjects = (dictionary["media"] as? [[String:Any]])

        guard let media = mediaObjects?.flatMap({ Media(dictionary: $0) }), media.count > 0 else {
            return nil
        }

        self.url = url
        self.title = title
        self.author = author
        self.summary = summary
        self.body = body
        self.publishedAt = publishedAt
        self.media = media

    }

    func dictionary() -> [String:Any] {

        return [
            "url": self.url.absoluteString,
            "title": self.title,
            "author": self.author,
            "summary": self.summary,
            "body": self.body,
            "published_at": self.publishedAt,
            "media": self.media.map { $0.dictionary() }
        ]

    }

}

extension Content.Media {

    init?(dictionary: [String:Any]?) {

        guard let dictionary = dictionary else {
            return nil
        }

        guard let url = URL(string: dictionary["url"] as? String) else {
            return nil
        }

        guard let type = dictionary["type"] as? String else {
            return nil
        }

        guard let role = dictionary["role"] as? String else {
            return nil
        }

        self.url = url
        self.type = type
        self.role = role

    }

    func dictionary() -> [String:Any] {

        return [
            "url": self.url.absoluteString,
            "type": self.type,
            "role": self.role
        ]

    }

}

extension Content: Equatable {

    public static func ==(lhs: Content, rhs: Content) -> Bool {

        return lhs.url == rhs.url
            && lhs.title == rhs.title
            && lhs.author == rhs.author
            && lhs.summary == rhs.summary
            && lhs.body == rhs.body
            && lhs.publishedAt == rhs.publishedAt
            && lhs.media == rhs.media

    }

}

extension Content.Media: Equatable {

    public static func ==(lhs: Content.Media, rhs: Content.Media) -> Bool {

        return lhs.url == rhs.url
            && lhs.type == rhs.type
            && lhs.role == rhs.role

    }
    
}
