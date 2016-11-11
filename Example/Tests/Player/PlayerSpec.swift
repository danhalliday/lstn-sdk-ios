//
//  PlayerSpec.swift
//  Lstn
//
//  Created by Dan Halliday on 17/10/2016.
//  Copyright © 2016 Lstn Ltd. All rights reserved.
//

import Quick
import Nimble
import Foundation

@testable import Lstn

private let timeout = 5.0 // TODO: Implement mock audio engine to avoid reading from disk

class PlayerSpec: QuickSpec {

    private let article = "article-id-string"
    private let publisher = "publisher-token-string"

    override func spec() {

        describe("Default Player") {

            it("should exist") {
                _ = DefaultPlayer.self
            }

            it("should load a URL") {
                DefaultPlayer().load(article: self.article, publisher: self.publisher)
            }

            describe("callback interface") {

                it("should call back after loading a URL") {

                    let player = DefaultPlayer(resolver: SucceedingArticleResolver())
                    var result: Bool? = nil

                    player.load(article: self.article, publisher: self.publisher) {
                        success in result = success
                    }

                    expect(result).toEventually(equal(true), timeout: timeout)

                }

            }

            describe("delegate interface") {

                it("should successfully load an article") {

                    let player = DefaultPlayer(resolver: SucceedingArticleResolver())
                    let spy = PlayerSpy()

                    player.delegate = spy
                    player.load(article: self.article, publisher: self.publisher)

                    expect(spy.loadingDidStartFired).toEventually(equal(true), timeout: timeout)
                    expect(spy.loadingDidFinishFired).toEventually(equal(true), timeout: timeout)

                }

                it("should fail to load an article if article resolution fails") {

                    let player = DefaultPlayer(resolver: FailingArticleResolver())
                    let spy = PlayerSpy()

                    player.delegate = spy
                    player.load(article: self.article, publisher: self.publisher)

                    expect(spy.loadingDidStartFired).toEventually(equal(true), timeout: timeout)
                    expect(spy.loadingDidFailFired).toEventually(equal(true), timeout: timeout)
                    
                }

            }

        }

    }

}
