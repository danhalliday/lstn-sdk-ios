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

    var workingPopSoundPath: String {
        return Bundle(for: type(of: self)).path(forResource: "Pop", ofType: "m4a")!
    }

    func resolve(source: URL, callback: ((ContentResolverState) -> Void)?) {

        let content = Content(dictionary: [
            "url": "https://example.com/articles/1",
            "title": "Content title",
            "author": "Jane Doe",
            "summary": "Content summary",
            "body": "Content body",
            "published_at": "2000-01-01T00:00:000Z",
            "media": [
                [
                    "url": "file://\(self.workingPopSoundPath)",
                    "type": "audio/mp3",
                    "role": "summary"
                ]
            ]
        ])!

        callback?(.started)
        callback?(.resolved(content))

    }

}

class FailingContentResolver: ContentResolver {

    func resolve(source: URL, callback: ((ContentResolverState) -> Void)?) {

        callback?(.started)
        callback?(.failed)

    }
    
}
