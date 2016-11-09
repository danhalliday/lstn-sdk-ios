//
//  ArticleSpec.swift
//  Lstn
//
//  Created by Dan Halliday on 09/11/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Quick
import Nimble
import Foundation

@testable import Lstn

class ArticleSpec: QuickSpec {

    override func spec() {

        describe("Article Model") {

            it("should exist") {
                _ = Article.self
            }

        }

    }

}
