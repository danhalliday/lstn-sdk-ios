//
//  LstnSDKExampleTests.swift
//  LstnSDKExampleTests
//
//  Created by Dan Halliday on 12/10/2016.
//  Copyright © 2016 Lstn Ltd. All rights reserved.
//

import XCTest
@testable import LstnSDKExample
import LstnSDK

class LstnSDKExampleTests: XCTestCase {

    func testLstnSDKImport() {
        Lstn.shared.start()
    }

}
