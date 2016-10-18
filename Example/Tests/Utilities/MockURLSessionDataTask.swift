//
//  MockURLSessionDataTask.swift
//  Lstn
//
//  Created by Dan Halliday on 18/10/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
@testable import Lstn

class MockURLSessionDataTask: URLSessionDataTaskType {

    var resumeFired = false
    var cancelFired = false

    var completionHandler: () -> Void

    init(completionHandler: @escaping () -> Void) {
        self.completionHandler = completionHandler
    }

    func resume() {
        self.resumeFired = true
        self.completionHandler()
    }

    func cancel() {
        self.cancelFired = true
    }
    
}
