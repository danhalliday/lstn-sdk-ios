//
//  Player.swift
//  Pods
//
//  Created by Dan Halliday on 17/10/2016.
//
//

import Foundation

/// Lstn's article player.
///
/// The `Player` loads text articles and plays them as spoken audio using Lstn's web service.
///
@objc public protocol Player: class {

    /// A delegate which receives `Player` events, such as `loadingDidFinish`, `playbackDidProgress`.
    ///
    weak var delegate: PlayerDelegate? { get set }

    /// Load an article with the given article and publisher IDs.
    ///
    func load(article: String, publisher: String)

    /// Load an article with the given article and publisher IDs, and call back once finished.
    ///
    func load(article: String, publisher: String, complete: @escaping PlayerCallback)

    /// Play the currently loaded article
    ///
    func play()

    /// Play the currently loaded article, and call back once playback has started.
    ///
    func play(complete: @escaping PlayerCallback)

    /// Stop playing the currently loaded article
    ///
    func stop()

    /// Stop playing the currently loaded article, and call back once stopping is complete.
    ///
    func stop(complete: @escaping PlayerCallback)

    /// Play or stop, depending on the state of the player
    ///
    func toggle()

    /// Play or stop, depending on the state of the player, and call back once finished
    ///
    func toggle(complete: @escaping PlayerCallback)

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

    func requestPreviousItem()
    func requestNextItem()

}

/// Success/failure callback type for `Player` methods.
///
public typealias PlayerCallback = (Bool) -> Void
