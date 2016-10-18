//
//  URLSessionType.swift
//  Pods
//
//  Created by Dan Halliday on 18/10/2016.
//
//

import Foundation

/*
 Protocols for fat free dependency injection of URLSession and friends
 */

// MARK: - URL Session

public protocol URLSessionType {

    func dataTask(with url: URL, completionHandler: @escaping URLSessionDataTaskCallbackType) -> URLSessionDataTaskType

}

extension URLSession: URLSessionType {

    public func dataTask(with url: URL, completionHandler: @escaping URLSessionDataTaskCallbackType) -> URLSessionDataTaskType {
        return self.dataTask(with: url, completionHandler: completionHandler) as URLSessionDataTask
    }
    
}

// MARK: - URL Session Data Task

public protocol URLSessionDataTaskType {

    func resume()
    func cancel()

}

public typealias URLSessionDataTaskCallbackType = (Data?, URLResponse?, Error?) -> Void

extension URLSessionDataTask: URLSessionDataTaskType {}
