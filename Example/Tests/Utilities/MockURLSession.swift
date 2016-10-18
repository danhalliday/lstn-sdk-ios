//
//  MockURLSession.swift
//  Lstn
//
//  Created by Dan Halliday on 18/10/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
@testable import Lstn

class MockURLSession: URLSessionType {

    let data: Data?
    let response: URLResponse?
    let error: Error?

    var dataTaskFired: Bool = false
    var dataTaskUrl: URL? = nil

    init(data: Data? = nil, response: URLResponse? = nil, error: Error? = nil) {

        self.data = data
        self.error = error

        let url = URL(string: "http://example.com")!

        self.response = response
            ?? HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)

    }

    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskType {

        self.dataTaskFired = true
        self.dataTaskUrl = url

        return MockURLSessionDataTask {
            completionHandler(self.data, self.response, self.error)
        }

    }

}
