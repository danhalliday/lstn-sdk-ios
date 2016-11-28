//
//  ArticleResolverSpec.swift
//  Lstn
//
//  Created by Dan Halliday on 09/11/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Quick
import Nimble
import Foundation

@testable import Lstn

class ArticleResolverSpec: QuickSpec {

    let key = ArticleKey(id: "123", publisher: "456")
    let endpoint = URL(string: "https://example.com/v1")!

    let response: [String:Any] = [
        "id": "12345",
        "url": "https://example.com/article.html",
        "title": "Title",
        "author": "Author",
        "image": "https://example.com/image.jpg",
        "state": "processed",
        "media": [
            [
                "role": "summary",
                "type": "audio/wav",
                "url": "https://example.com/audio.mp3"
            ]
        ]
    ]

    override func spec() {

        describe("Remote Article Resolver") {

            it("should exist") {
                _ = RemoteArticleResolver.self
            }

            it("should report that resolution has started") {

                let session = MockURLSession()
                let resolver = RemoteArticleResolver(session: session)
                let spy = ArticleResolverSpy()

                resolver.delegate = spy
                resolver.resolve(key: self.key)

                expect(spy.resolutionDidStartFired).toEventually(equal(true))
                expect(spy.key).toEventually(equal(self.key))

            }

            it("should make a valid network request for a given article") {

                let session = MockURLSession()
                let resolver = RemoteArticleResolver(endpoint: self.endpoint, session: session)
                let url = self.endpoint.appendingPathComponent("/publishers/456/articles/123")

                resolver.resolve(key: self.key)

                expect(session.dataTaskFired).toEventually(equal(true))
                expect(session.dataTaskUrl).toEventually(equal(url))
                
            }

            it("should return a valid model object for a successful request") {

                let data = try! JSONSerialization.data(withJSONObject: self.response)
                let session = MockURLSession(data: data)
                let resolver = RemoteArticleResolver(endpoint: self.endpoint, session: session)
                let spy = ArticleResolverSpy()

                resolver.delegate = spy
                resolver.resolve(key: self.key)

                expect(spy.resolutionDidFinishFired).toEventually(equal(true))
                expect(spy.article?.title).toEventually(equal("Title"))
                expect(spy.article?.publisher).toEventually(equal("Lstn"))

            }

            it("should return an error when the network is unreachable") {

                enum SpecError: Error { case general }

                let session = MockURLSession(error: SpecError.general)
                let resolver = RemoteArticleResolver(endpoint: self.endpoint, session: session)
                let spy = ArticleResolverSpy()

                resolver.delegate = spy
                resolver.resolve(key: self.key)

                expect(spy.resolutionDidFailFired).toEventually(beTrue())

            }

            it("should return an error when the response is invalid") {

                let response = ["invalid": "response"]
                let data = try! JSONSerialization.data(withJSONObject: response)
                let session = MockURLSession(data: data)
                let resolver = RemoteArticleResolver(endpoint: self.endpoint, session: session)
                let spy = ArticleResolverSpy()

                resolver.delegate = spy
                resolver.resolve(key: self.key)

                expect(spy.resolutionDidFailFired).toEventually(beTrue())

            }

        }
        
    }
    
}
