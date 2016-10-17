//
//  PlayerTests.swift
//  Lstn
//
//  Created by Dan Halliday on 17/10/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Quick
import Nimble
import Lstn

class PlayerSpec: QuickSpec {
    override func spec() {
        describe("player") {

            it("loads a URL") {
                let player = Player()
                let url = URL(string: "http://apple.com")!

                waitUntil { done in
                    player.load(url: url) { success in
                        done()
                    }
                }
            }

        }
    }
}
