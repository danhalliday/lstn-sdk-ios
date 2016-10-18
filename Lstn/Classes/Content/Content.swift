//
//  Content.swift
//  Pods
//
//  Created by Dan Halliday on 18/10/2016.
//
//

import Foundation

public struct Content {

    let source: URL
    let title: String
    let media: [URL]

}

extension Content {

    init?(dictionary: [String:Any]?) {

        guard let dictionary = dictionary else {
            return nil
        }

        guard let source = URL(string: dictionary["source"] as? String) else {
            return nil
        }

        guard let title = dictionary["title"] as? String else {
            return nil
        }

        guard let media = (dictionary["media"] as? [String])?.flatMap({ URL(string: $0) }), media.count > 0 else {
            return nil
        }

        self.source = source
        self.title = title
        self.media = media

    }

    func dictionary() -> [String:Any] {

        return [
            "source": self.source.absoluteString,
            "title": self.title,
            "media": self.media.map { $0.absoluteString }
        ]

    }

}

extension Content: Equatable {

    public static func ==(lhs: Content, rhs: Content) -> Bool {

        return lhs.source == rhs.source
            && lhs.title == rhs.title
            && lhs.media == rhs.media

    }

}
