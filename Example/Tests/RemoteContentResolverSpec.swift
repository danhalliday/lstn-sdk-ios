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

        describe("content resolver") {

            it("should make a network request for a given source") {

                let session = MockURLSession()
                let resolver = RemoteContentResolver(session: session)

                let sourceUrl = URL(string: "http://apple.com")!
                let requestUrl = URL(string: "https://api.lstn.ltd/articles?source=http%3A%2F%2Fapple.com")!

                resolver.resolve(source: sourceUrl)

                expect(session.dataTaskFired).toEventually(equal(true))
                expect(session.dataTaskUrl).toEventually(equal(requestUrl))
                
            }

            it("should return a valid result for a successful request") {

                let response = ["https://one.com", "https://two.com", "https://three.com"]
                let data = try! JSONSerialization.data(withJSONObject: response, options: [])

                let session = MockURLSession(data: data)
                let resolver = RemoteContentResolver(session: session)

                let url = URL(string: "http://apple.com/")!
                var result: ContentResolverResult? = nil

                resolver.resolve(source: url) { state in
                    if case let .succeeded(r) = state { result = r }
                }

                expect(result).toEventually(contain([URL(string: "https://one.com")!]))
                
            }

            it("should return an error when the network is unreachable") {

                let session = MockURLSession(error: SpecError.general)
                let resolver = RemoteContentResolver(session: session)

                let sourceUrl = URL(string: "http://apple.com")!
                var error: ContentResolverError? = nil

                resolver.resolve(source: sourceUrl) { state in
                    if case let .failed(e) = state { error = e }
                }

                expect(error).toEventuallyNot(beNil())

            }

            it("should return an error when the response is invalid") {

                let response = ["invalid": "dictionary"]
                let data = try! JSONSerialization.data(withJSONObject: response, options: [])

                let session = MockURLSession(data: data)
                let resolver = RemoteContentResolver(session: session)

                let sourceUrl = URL(string: "http://apple.com/")!
                var error: ContentResolverError? = nil

                resolver.resolve(source: sourceUrl) { state in
                    if case let .failed(e) = state { error = e }
                }

                expect(error).toEventuallyNot(beNil())

            }

        }

    }

}

