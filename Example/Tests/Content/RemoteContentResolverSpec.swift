//
//  RemoteContentResolverSpec.swift
//  Lstn
//
//  Created by Dan Halliday on 17/10/2016.
//  Copyright © 2016 Lstn Ltd. All rights reserved.
//

import Quick
import Nimble
import Foundation

@testable import Lstn

class RemoteContentResolverSpec: QuickSpec {

    enum SpecError: Error {
        case general
    }

    override func spec() {

        describe("Content Resolver") {

            it("should report that resolution has started") {

                let session = MockURLSession()
                let resolver = RemoteContentResolver(session: session)

                let sourceUrl = URL(string: "http://example.com")!
                var started = false

                resolver.resolve(source: sourceUrl) { state in
                    if case .started = state { started = true }
                }

                expect(started).toEventually(equal(true))
                
            }

            it("should make a network request for a given source") {

                let session = MockURLSession()
                let resolver = RemoteContentResolver(session: session)

                let sourceUrl = URL(string: "http://example.com")!
                let requestUrl = URL(string: "\(Lstn.API)/content/?source=http%3A%2F%2Fexample.com")!

                resolver.resolve(source: sourceUrl)

                expect(session.dataTaskFired).toEventually(equal(true))
                expect(session.dataTaskUrl).toEventually(equal(requestUrl))

            }

            it("should return a valid result for a successful request") {

                let content = Content(dictionary: [
                    "url": "https://example.com/articles/1",
                    "title": "Content title",
                    "author": "Jane Doe",
                    "summary": "Content summary",
                    "body": "Content body",
                    "published_at": "2000-01-01T00:00:000Z",
                    "media": [
                        [
                            "url": "https://example.com/articles/1/media.mp3",
                            "type": "audio/mp3",
                            "role": "summary"
                        ]
                    ]
                ])!

                let data = try! JSONSerialization.data(withJSONObject: content.dictionary())

                let session = MockURLSession(data: data)
                let resolver = RemoteContentResolver(session: session)

                let url = URL(string: "http://example.com/")!
                var result: Content? = nil

                resolver.resolve(source: url) { state in
                    if case let .resolved(r) = state { result = r }
                }

                expect(result).toEventually(equal(content))

            }

            it("should return an error when the network is unreachable") {

                let session = MockURLSession(error: SpecError.general)
                let resolver = RemoteContentResolver(session: session)

                let sourceUrl = URL(string: "http://example.com")!
                var failed = false

                resolver.resolve(source: sourceUrl) { state in
                    if case .failed = state { failed = true }
                }

                expect(failed).toEventually(beTrue())

            }

            it("should return an error when the response is invalid") {

                let response = ["invalid": "response"]
                let data = try! JSONSerialization.data(withJSONObject: response, options: [])

                let session = MockURLSession(data: data)
                let resolver = RemoteContentResolver(session: session)

                let sourceUrl = URL(string: "http://example.com/")!
                var failed = false

                resolver.resolve(source: sourceUrl) { state in
                    if case .failed = state { failed = true }
                }

                expect(failed).toEventually(beTrue())

            }

        }

    }

}

