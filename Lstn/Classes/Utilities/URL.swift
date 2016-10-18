//
//  URL.swift
//  Pods
//
//  Created by Dan Halliday on 18/10/2016.
//
//

import Foundation

/*
 Convenience initialiser for URL with optional strings
 */

extension URL {

    init?(string: String?) {
        self.init(string: string ?? "")
    }
    
}
