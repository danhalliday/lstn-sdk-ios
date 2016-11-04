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

    let url = "https://example.com/articles/1"
    let title = "Content title"
    let author = "Jane Doe"
    let summary = "Content summary"
    let body = "Content body"
    let publishedAt = "2000-01-01T00:00:000Z"
    let media = ["url": "https://exaple.com/media.mp3", "type": "audio/mp3", "role": "summary"]

    override func spec() {

        describe("Content Model") {

            it("should initialise with a valid dictionary") {

                let content = Content(dictionary: [
                    "url": self.url,
                    "title": self.title,
                    "author": self.author,
                    "summary": self.summary,
                    "body": self.body,
                    "published_at": self.publishedAt,
                    "media": [self.media]
                ])

                expect(content).toNot(beNil())
                expect(content?.title).to(equal("Content title"))
                expect(content?.media.count).to(equal(1))

            }

            it("should fail to initialise with a nil dictionary") {

                let content = Content(dictionary: nil)
                expect(content).to(beNil())

            }

            it("should fail to initialise with missing title key") {

                let content = Content(dictionary: [
                    "url": self.url,
                    "author": self.author,
                    "summary": self.summary,
                    "body": self.body,
                    "published_at": self.publishedAt,
                    "media": [self.media]
                ])

                expect(content).to(beNil())
                
            }

            it("should fail to initialise with missing media key") {

                let content = Content(dictionary: [
                    "url": self.url,
                    "title": self.title,
                    "author": self.author,
                    "summary": self.summary,
                    "body": self.body,
                    "published_at": self.publishedAt
                ])

                expect(content).to(beNil())
                
            }

            it("should fail to initialise with zero media items") {

                let content = Content(dictionary: [
                    "url": self.url,
                    "title": self.title,
                    "author": self.author,
                    "summary": self.summary,
                    "body": self.body,
                    "published_at": self.publishedAt,
                    "media": [/* empty */]
                ])

                expect(content).to(beNil())
                
            }

            it("should fail to initialise with invalid media URLs") {

                let invalidMedia = [
                    "url": "invalid media url",
                    "type": "audio/mp3", "role": "summary"
                ]

                let content = Content(dictionary: [
                    "url": self.url,
                    "title": self.title,
                    "author": self.author,
                    "summary": self.summary,
                    "body": self.body,
                    "published_at": self.publishedAt,
                    "media": [invalidMedia]
                ])

                expect(content).to(beNil())
                
            }

        }

    }

}
