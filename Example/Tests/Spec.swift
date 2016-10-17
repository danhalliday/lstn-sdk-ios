// https://github.com/Quick/Quick

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
