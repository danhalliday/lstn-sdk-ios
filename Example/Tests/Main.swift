//
//  Main.swift
//  Lstn
//
//  Created by Dan Halliday on 17/10/2016.
//  Copyright © 2016 Lstn Ltd. All rights reserved.
//

import Quick
import Nimble
import Lstn

class LstnSpec: QuickSpec {
    override func spec() {
        describe("singleton interface") {

            it("should exist") {
                _ = Lstn.shared
            }

        }
    }
}
