//
//  Article.swift
//  Pods
//
//  Created by Dan Halliday on 09/11/2016.
//
//

import Foundation

struct Article {

    let key: ArticleKey

    let source: URL
    let audio: URL
    let image: URL

    let title: String
    let author: String
    let publisher: String

}

struct ArticleKey {

    let id: String
    let source: String
    let publisher: String

}

extension Article: Equatable {

    static func ==(lhs: Article, rhs: Article) -> Bool {

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

    static func ==(lhs: ArticleKey, rhs: ArticleKey) -> Bool {

        return lhs.id == rhs.id && lhs.publisher == rhs.publisher

    }

}

extension ArticleKey: Hashable {

    var hashValue: Int {
        return "\(self.id)\(self.source)\(self.publisher)".hashValue
    }

}
