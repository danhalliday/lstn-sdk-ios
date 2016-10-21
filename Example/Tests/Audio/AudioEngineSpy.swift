//
//  AudioEngineSpy.swift
//  Lstn
//
//  Created by Dan Halliday on 19/10/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
@testable import Lstn

class AudioEngineSpy: AudioEngineDelegate {

    var loadingDidStartFired = false
    var loadingDidFinishFired = false
    var loadingDidFinishCallback: (() -> Void)?
    var loadingDidFailFired = false

    func loadingDidStart() {
        self.loadingDidStartFired = true
    }

    func loadingDidFinish() {
        self.loadingDidFinishFired = true
        self.loadingDidFinishCallback?()
    }

    func loadingDidFail() {
        self.loadingDidFailFired = true
    }

    var playbackDidStartFired = false
    var playbackDidProgressFired = false
    var playbackDidStopFired = false
    var playbackDidFinishFired = false
    var playbackDidFailFired = false

    func playbackDidStart() {
        self.playbackDidStartFired = true
    }

    func playbackDidProgress(amount: Double) {
        self.playbackDidProgressFired = true
    }

    func playbackDidStop() {
        self.playbackDidStopFired = true
    }

    func playbackDidFinish() {
        self.playbackDidFinishFired = true
    }

    func playbackDidFail() {
        self.playbackDidFailFired = true
    }

}
