//
//  URLSessionType.swift
//  Pods
//
//  Created by Dan Halliday on 18/10/2016.
//
//

import Foundation

/*
 Fat free dependency injection of URLSession and friends
 */

public protocol URLSessionType {

    func dataTask(with url: URL, completionHandler: @escaping URLSessionDataTaskCallbackType) -> URLSessionDataTaskType

}

extension URLSession: URLSessionType {

    public func dataTask(with url: URL, completionHandler: @escaping URLSessionDataTaskCallbackType) -> URLSessionDataTaskType {
        return self.dataTask(with: url, completionHandler: completionHandler) as URLSessionDataTask
    }
    
}
