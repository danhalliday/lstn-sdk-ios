//
//  AudioEngineSpec.swift
//  Lstn
//
//  Created by Dan Halliday on 19/10/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Quick
import Nimble
import Foundation

@testable import Lstn

private let timeout = 5.0 // Need a little time as no way to avoid reading from disk...

class AudioEngineSpec: QuickSpec {

    var workingPopSoundPath: String {
        return Bundle(for: type(of: self)).path(forResource: "Pop", ofType: "m4a")!
    }

    var corruptPopSoundPath: String {
        return Bundle(for: type(of: self)).path(forResource: "PopCorrupt", ofType: "m4a")!
    }

    let invalidPopSoundPath = "/invalid/path/to/file.m4a"

    override func spec() {

        describe("Audio Engine") {

            it("should load a local item") {

                let engine = DefaultAudioEngine()
                let spy = AudioEngineSpy()

                let url = URL(fileURLWithPath: self.workingPopSoundPath)

                engine.delegate = spy
                engine.load(url: url)

                expect(spy.loadingDidFinishFired).toEventually(equal(true), timeout: timeout)

            }

            it("should fail to load an unreachable item") {

                let engine = DefaultAudioEngine()
                let spy = AudioEngineSpy()

                let url = URL(fileURLWithPath: self.invalidPopSoundPath)

                engine.delegate = spy
                engine.load(url: url)

                expect(spy.loadingDidFailFired).toEventually(equal(true), timeout: timeout)

            }

            it("should fail to load a corrupt file") {

                let engine = DefaultAudioEngine()
                let spy = AudioEngineSpy()

                let url = URL(fileURLWithPath: self.corruptPopSoundPath)

                engine.delegate = spy
                engine.load(url: url)

                expect(spy.loadingDidFailFired).toEventually(equal(true), timeout: timeout)

            }

            it("should report playback did start") {

                let engine = DefaultAudioEngine()
                let spy = AudioEngineSpy()

                let url = URL(fileURLWithPath: self.workingPopSoundPath)

                spy.loadingDidFinishCallback = {
                    engine.play()
                }

                engine.delegate = spy
                engine.load(url: url)

                expect(spy.playbackDidStartFired).toEventually(equal(true), timeout: timeout)

            }

            it("should report playback did stop") {

                let engine = DefaultAudioEngine()
                let spy = AudioEngineSpy()

                let url = URL(fileURLWithPath: self.workingPopSoundPath)

                spy.loadingDidFinishCallback = {
                    engine.play()
                    engine.stop()
                }

                engine.delegate = spy
                engine.load(url: url)

                expect(spy.playbackDidStopFired).toEventually(equal(true), timeout: timeout)

            }

            it("should report playback did finish") {

                let engine = DefaultAudioEngine()
                let spy = AudioEngineSpy()

                let url = URL(fileURLWithPath: self.workingPopSoundPath)

                spy.loadingDidFinishCallback = {
                    engine.play()
                }

                engine.delegate = spy
                engine.load(url: url)

                expect(spy.playbackDidFinishFired).toEventually(equal(true), timeout: timeout)

            }

        }

    }

}
