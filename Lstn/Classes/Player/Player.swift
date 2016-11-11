//
//  Player.swift
//  Pods
//
//  Created by Dan Halliday on 17/10/2016.
//
//

import Foundation

/// Lstn's podcast player.
///
/// The `Player` loads text articles and plays them as spoken audio using Lstn's web service.
///
@objc public protocol Player: class {

    /// A delegate which receives `Player` events
    ///
    weak var delegate: PlayerDelegate? { get set }

    func load(article: String, publisher: String)
    func load(article: String, publisher: String, complete: @escaping PlayerCallback)

    func play()
    func play(complete: @escaping PlayerCallback)

    func stop()
    func stop(complete: @escaping PlayerCallback)

}

/// Event delegate protocol for `Player`.
///
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

/// Success/failure callback type for `Player` methods.
///
public typealias PlayerCallback = (Bool) -> Void
