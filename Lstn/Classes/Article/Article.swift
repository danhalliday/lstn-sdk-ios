//
//  Article.swift
//  Pods
//
//  Created by Dan Halliday on 09/11/2016.
//
//

import Foundation

public struct Article {

    let key: ArticleKey

    let source: URL
    let audio: URL
    let image: URL

    let title: String
    let author: String
    let publisher: String

}

public struct ArticleKey {

    let id: String
    let publisher: String

}

extension Article: Equatable {

    public static func ==(lhs: Article, rhs: Article) -> Bool {

        return lhs.key == rhs.key
            && lhs.source == rhs.source
            && lhs.audio == rhs.audio
            && lhs.image == rhs.image
            && lhs.title == rhs.title
            && lhs.author == rhs.author
            && lhs.publisher == rhs.publisher

    }

}

extension ArticleKey: Equatable {

    public static func ==(lhs: ArticleKey, rhs: ArticleKey) -> Bool {

        return lhs.id == rhs.id && lhs.publisher == rhs.publisher

    }

}

extension ArticleKey: Hashable {

    public var hashValue: Int {
        return "\(self.id)\(self.publisher)".hashValue
    }

}
