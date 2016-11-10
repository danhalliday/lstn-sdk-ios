//
//  AudioEngine.swift
//  Pods
//
//  Created by Dan Halliday on 19/10/2016.
//
//

import Foundation

protocol AudioEngine {

    func load(url: URL)

    func play()
    func stop()

    weak var delegate: AudioEngineDelegate? { get set }

    var elapsedTime: Double { get }
    var totalTime: Double { get }

}

protocol AudioEngineDelegate: class {

    func loadingDidStart()
    func loadingDidFinish()
    func loadingDidFail()

    func playbackDidStart()
    func playbackDidProgress(amount: Double)
    func playbackDidStop()
    func playbackDidFinish()
    func playbackDidFail()

}
