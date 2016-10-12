//
//  LstnSDKTests.swift
//  LstnSDKTests
//
//  Created by Dan Halliday on 12/10/2016.
//  Copyright © 2016 Lstn Ltd. All rights reserved.
//

import XCTest
@testable import LstnSDK

class LstnSDKTests: XCTestCase {

    func testSingletonSetup() {
        Lstn.shared.start()
    }

}
