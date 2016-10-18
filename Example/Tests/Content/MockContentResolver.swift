//
//  MockContentResolver.swift
//  Lstn
//
//  Created by Dan Halliday on 18/10/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
@testable import Lstn

class SucceedingContentResolver: ContentResolver {

    func resolve(source: URL, callback: ((ContentResolverState) -> Void)?) {
        callback?(.started)
        callback?(.succeeded([]))
    }

}

class FailingContentResolver: ContentResolver {

    func resolve(source: URL, callback: ((ContentResolverState) -> Void)?) {
        callback?(.started)
        callback?(.failed(.unknown(nil)))
    }
    
}
