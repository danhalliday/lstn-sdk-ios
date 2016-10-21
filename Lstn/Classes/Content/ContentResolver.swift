//
//  ContentResolver.swift
//  Pods
//
//  Created by Dan Halliday on 17/10/2016.
//
//

import Foundation

public protocol ContentResolver {

    func resolve(source: URL, callback: ((ContentResolverState) -> Void)?)

}

public enum ContentResolverState {

    case started
    case resolved(Content)
    case failed
    case cancelled

}
