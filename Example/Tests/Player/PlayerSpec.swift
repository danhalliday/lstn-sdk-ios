//
//  PlayerSpec.swift
//  Lstn
//
//  Created by Dan Halliday on 17/10/2016.
//  Copyright © 2016 Lstn Ltd. All rights reserved.
//

import Quick
import Nimble
import Lstn

class PlayerSpec: QuickSpec {

    override func spec() {

        describe("player") {

            it("loads a URL") {

                let player = Player()
                let url = URL(string: "http://example.com")!

                player.load(source: url)

            }

            describe("callback interface") {

                it("calls back after loading a URL") {

                    let player = Player(resolver: SucceedingContentResolver())
                    let url = URL(string: "http://example.com")!
                    var result: Bool? = nil

                    player.load(source: url) { success in
                        result = success
                    }

                    expect(result).toEventually(equal(true), timeout: 10)

                }

            }

            describe("delegate interface") {

                it("calls its delegate after loading a URL") {

                    let player = Player(resolver: SucceedingContentResolver())
                    let url = URL(string: "http://example.com")!
                    let spy = PlayerSpy()

                    player.delegate = spy
                    player.load(source: url)

                    expect(spy.loadingDidStartFired).toEventually(equal(true), timeout: 10)
                    expect(spy.loadingDidFinishFired).toEventually(equal(true), timeout: 10)

                }

            }

        }

    }

}