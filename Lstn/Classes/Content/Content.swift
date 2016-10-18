//
//  Content.swift
//  Pods
//
//  Created by Dan Halliday on 18/10/2016.
//
//

import Foundation

struct Content {

    let source: URL
    let title: String
    let media: [URL]

}

extension Content {

    init?(dictionary: [String:Any]?) {

        guard let dictionary = dictionary else {
            return nil
        }

        guard let source = URL(string: dictionary["source"] as? String) else {
            return nil
        }

        guard let title = dictionary["title"] as? String else {
            return nil
        }

        guard let mediaStrings = dictionary["media"] as? [String], mediaStrings.count > 0 else {
            return nil
        }

        let media = mediaStrings.flatMap { URL(string: $0) }

        if media.count == 0 {
            return nil
        }

        self.source = source
        self.title = title
        self.media = media

    }

}
