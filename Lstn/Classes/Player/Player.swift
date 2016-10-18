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

    public init(resolver: ContentResolver = RemoteContentResolver()) {
        self.resolver = resolver
    }

    public func load(url: URL, complete: Callback? = nil) {

        self.resolver.resolve(source: url) { state in

            switch state {

            case .started:
                self.delegate?.loadingDidStart()

            case .resolved:
                self.delegate?.loadingDidFinish()
                complete?(true)

            case .failed:
                self.delegate?.loadingDidFail()
                complete?(false)

            }

        }

    }

    public func play(complete: Callback? = nil) {
        self.delegate?.playbackDidStart()
    }

    public func stop(complete: Callback? = nil) {
        self.delegate?.playbackDidStop()
    }

}
