//
//  URLSessionDataTaskType.swift
//  Pods
//
//  Created by Dan Halliday on 18/10/2016.
//
//

import Foundation

/*
 Fat free dependency injection of URLSession and friends
 */

public protocol URLSessionDataTaskType {

    func resume()
    func cancel()

}

public typealias URLSessionDataTaskCallbackType = (Data?, URLResponse?, Error?) -> Void

extension URLSessionDataTask: URLSessionDataTaskType {}
