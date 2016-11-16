//
//  Example.swift
//  Lstn
//
//  Created by Dan Halliday on 18/10/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Lstn

class Example {

    let player = Lstn.createPlayer()

    let article = "12345-an-article-id"
    let publisher = "12345-a-publisher-id"

    var loading = false
    var playing = false
    var progress = 0.0
    var error = false

    init() {
        self.player.delegate = self
    }

    func loadButtonWasTapped() {
        self.player.load(article: self.article, publisher: self.publisher)
    }

    func playButtonWasTapped() {
        self.player.play()
    }

    func stopButtonWasTapped() {
        self.player.stop()
    }

}

extension Example: PlayerDelegate {

    func loadingDidStart() {
        self.loading = true
        self.error = false
    }

    func loadingDidFinish() {
        self.loading = false
    }

    func loadingDidFail() {
        self.loading = false
        self.error = true
    }

    func playbackDidStart() {
        self.playing = true
        self.error = false
    }

    func playbackDidProgress(amount: Double) {
        self.progress = amount
    }

    func playbackDidStop() {
        self.playing = false
    }

    func playbackDidFinish() {
        self.playing = false
    }

    func playbackDidFail() {
        self.playing = false
        self.error = true
    }

}
