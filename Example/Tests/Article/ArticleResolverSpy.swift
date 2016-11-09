//
//  ArticleResolverSpy.swift
//  Lstn
//
//  Created by Dan Halliday on 09/11/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

@testable import Lstn

class ArticleResolverSpy: ArticleResolverDelegate {

    var resolutionDidStartFired: Bool = false
    var resolutionDidFinishFired: Bool = false
    var resolutionDidFailFired: Bool = false

    var key: ArticleKey? = nil
    var article: Article? = nil

    func resolutionDidStart(key: ArticleKey) {
        self.key = key
        self.resolutionDidStartFired = true
    }

    func resolutionDidFinish(key: ArticleKey, article: Article) {
        self.key = key
        self.article = article
        self.resolutionDidFinishFired = true
    }

    func resolutionDidFail(key: ArticleKey) {
        self.key = key
        self.resolutionDidFailFired = true
    }

}
