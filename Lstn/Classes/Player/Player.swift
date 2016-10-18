//
//  Player.swift
//  Pods
//
//  Created by Dan Halliday on 17/10/2016.
//
//

import Foundation

public protocol PlayerDelegate: class {

    func loadingDidStart()
    func loadingDidFinish()
    func loadingDidFail()

    func playbackDidStart()
    func playbackDidProgress()
    func playbackDidStop()
    func playbackDidFinish()
    func playbackDidFail()

}

public class Player {

    public weak var delegate: PlayerDelegate? = nil
    private let resolver: ContentResolver

    public typealias Callback = (Bool) -> Void

    struct Callbacks {
        var load: Callback? = nil
        var play: Callback? = nil
        var stop: Callback? = nil
    }

    private var callbacks = Callbacks()

    public init(resolver: ContentResolver = RemoteContentResolver()) {
        self.resolver = resolver
    }

    public func load(url: URL, complete: Callback? = nil) {

        self.resolver.resolve(source: url) { state in

            switch state {

            case .started:
                self.delegate?.loadingDidStart()

            case .succeeded:
                self.delegate?.loadingDidFinish()
                complete?(true)

            case .failed:
                self.delegate?.loadingDidFail()
                complete?(false)

            }

        }

    }

    public func play(complete: Callback? = nil) {
        self.callbacks.play = complete
        self.delegate?.playbackDidStart()
        self.callbacks.play?(true)
    }

    public func stop(complete: Callback? = nil) {
        self.callbacks.stop = complete
        self.delegate?.playbackDidStop()
        self.callbacks.stop?(true)
    }

}
