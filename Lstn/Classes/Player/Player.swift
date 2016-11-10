//
//  Player.swift
//  Pods
//
//  Created by Dan Halliday on 17/10/2016.
//
//

import Foundation
import MediaPlayer

public protocol Player {

//    init()
//    init(resolver: ArticleResolver, engine: AudioEngine, control: RemoteControl)
//    nope - no public initialiser we're going to provide a factory method.

//    func load(article: String, publisher: String)
//    func load(article: String, publisher: String, complete: PlayerCallback)

//    func play()
//    func play(complete: PlayerCallback)

//    func stop()
//    func stop(complete: PlayerCallback)

}

@objc public protocol PlayerDelegate: class {

    func loadingDidStart()
    func loadingDidFinish()
    func loadingDidFail()

    func playbackDidStart()
    func playbackDidProgress(amount: Double)
    func playbackDidStop()
    func playbackDidFinish()
    func playbackDidFail()

}

public typealias PlayerCallback = (Bool) -> Void
