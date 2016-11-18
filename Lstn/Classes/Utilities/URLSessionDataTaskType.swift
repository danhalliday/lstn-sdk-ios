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

protocol URLSessionDataTaskType: class {

    func resume()
    func cancel()

    var state: URLSessionTask.State { get }

}

typealias URLSessionDataTaskCallbackType = (Data?, URLResponse?, Error?) -> Void

extension URLSessionDataTask: URLSessionDataTaskType {}
