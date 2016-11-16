//
//  Main.swift
//  Lstn
//
//  Created by Dan Halliday on 17/10/2016.
//  Copyright © 2016 Lstn Ltd. All rights reserved.
//

import Quick
import Nimble

@testable import Lstn

class LstnSpec: QuickSpec {

    override func spec() {

        describe("singleton interface") {

            it("should exist") {
                _ = Lstn.shared
            }

        }

        describe("configuration") {

            it("should read its token from the app bundle") {
                // TODO: Doesn't work because of Bundle/tests bug?
                // expect(Lstn.token).to(equal("test_api_key"))
            }

        }

    }

}
