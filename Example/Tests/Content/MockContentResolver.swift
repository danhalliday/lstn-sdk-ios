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

    let content = Content(dictionary: [
        "source": "https://example.com/articles/1",
        "title": "Example content item title",
        "media": [
            "https://example.com/articles/1/media.mp3",
            "https://example.com/articles/1/media.m3u8",
            "https://example.com/articles/1/media.m4a"
        ]
    ])!

    func resolve(source: URL, callback: ((ContentResolverState) -> Void)?) {
        callback?(.started)
        callback?(.resolved(self.content))
    }

}

class FailingContentResolver: ContentResolver {

    func resolve(source: URL, callback: ((ContentResolverState) -> Void)?) {
        callback?(.started)
        callback?(.failed(.unknown(nil)))
    }
    
}
