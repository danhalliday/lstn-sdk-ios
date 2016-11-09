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

            it("should make a network request for a given article") {

                let session = MockURLSession()
                let resolver = RemoteArticleResolver(endpoint: self.endpoint, session: session)
                let url = self.endpoint.appendingPathComponent("/publisher/456/articles/123/")

                resolver.resolve(key: self.key)

                expect(session.dataTaskFired).toEventually(equal(true))
                expect(session.dataTaskUrl).toEventually(equal(url))
                
            }

            it("should return a valid model object for a successful request") {

                let response = [
                    "title": "Article Title"
                ]

                let data = try! JSONSerialization.data(withJSONObject: response)
                let session = MockURLSession(data: data)
                let resolver = RemoteArticleResolver(endpoint: self.endpoint, session: session)
                let spy = ArticleResolverSpy()

                resolver.delegate = spy
                resolver.resolve(key: self.key)

                expect(spy.resolutionDidFinishFired).toEventually(equal(true))
                expect(spy.article?.title).toEventually(equal("Article Title"))

            }

        }
        
    }
    
}