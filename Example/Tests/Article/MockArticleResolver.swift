//
//  MockArticleResolver.swift
//  Lstn
//
//  Created by Dan Halliday on 10/11/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
@testable import Lstn

class SucceedingArticleResolver: ArticleResolver {

    weak var delegate: ArticleResolverDelegate? = nil

    var workingPopSoundPath: String {
        return Bundle(for: type(of: self)).path(forResource: "Pop", ofType: "m4a")!
    }

    func resolve(key: ArticleKey) {

        let article = Article(
            key: key,
            source: URL(string: "https://example.com/article.html")!,
            audio: URL(fileURLWithPath: self.workingPopSoundPath),
            image: URL(string: "https://example.com/image.jpg")!,
            title: "Title",
            author: "Author",
            publisher: "Publisher"
        )

        self.delegate?.resolutionDidStart(key: key)
        self.delegate?.resolutionDidFinish(key: key, article: article)

    }

}

class FailingArticleResolver: ArticleResolver {

    weak var delegate: ArticleResolverDelegate? = nil

    func resolve(key: ArticleKey) {

        self.delegate?.resolutionDidStart(key: key)
        self.delegate?.resolutionDidFail(key: key)

    }

}
