//
//  ContentSPec.swift
//  Lstn
//
//  Created by Dan Halliday on 18/10/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Quick
import Nimble
import Foundation

@testable import Lstn

class ContentSpec: QuickSpec {

    override func spec() {

        describe("Content Model") {

            it("should initialise with a valid dictionary") {

                let content = Content(dictionary: [
                    "source": "https://example.com/articles/1",
                    "title": "Example content item title",
                    "media": [
                        "https://example.com/articles/1/media.mp3",
                        "https://example.com/articles/1/media.m3u8",
                        "https://example.com/articles/1/media.m4a"
                    ]
                ])

                expect(content).toNot(beNil())

            }

            it("should fail to initialise with a nil dictionary") {

                let content = Content(dictionary: nil)
                expect(content).to(beNil())

            }

            it("should fail to initialise with missing source key") {

                let content = Content(dictionary: [
                    "title": "Example content item title",
                    "media": [
                        "https://example.com/articles/1/media.mp3",
                        "https://example.com/articles/1/media.m3u8",
                        "https://example.com/articles/1/media.m4a"
                    ]
                ])

                expect(content).to(beNil())

            }

            it("should fail to initialise with missing title key") {

                let content = Content(dictionary: [
                    "source": "https://example.com/articles/1",
                    "media": [
                        "https://example.com/articles/1/media.mp3",
                        "https://example.com/articles/1/media.m3u8",
                        "https://example.com/articles/1/media.m4a"
                    ]
                ])

                expect(content).to(beNil())
                
            }

            it("should fail to initialise with missing media key") {

                let content = Content(dictionary: [
                    "source": "https://example.com/articles/1",
                    "title": "Example content item title"
                ])

                expect(content).to(beNil())
                
            }

            it("should fail to initialise with zero media items") {

                let content = Content(dictionary: [
                    "source": "https://example.com/articles/1",
                    "title": "Example content item title",
                    "media": []
                ])

                expect(content).to(beNil())
                
            }

            it("should fail to initialise with invalid media URLs") {

                let content = Content(dictionary: [
                    "source": "https://example.com/articles/1",
                    "title": "Example content item title",
                    "media": ["invalid media item url"]
                ])

                expect(content).to(beNil())
                
            }

        }

    }

}
