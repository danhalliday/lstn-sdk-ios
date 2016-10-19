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
    func playbackDidProgress(amount: Double)
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

    public func load(source: URL, complete: Callback? = nil) {

        self.resolver.resolve(source: source) { state in

            switch state {

            case .started:
                self.dispatch {
                    self.delegate?.loadingDidStart()
                }

            case .resolved:
                self.dispatch {
                    self.delegate?.playbackDidStop()
                    self.delegate?.playbackDidProgress(amount: 0)
                    self.delegate?.loadingDidFinish()
                    complete?(true)
                }

            case .failed:
                self.dispatch {
                    self.delegate?.playbackDidStop()
                    self.delegate?.playbackDidProgress(amount: 0)
                    self.delegate?.loadingDidFail()
                    complete?(false)
                }

            }

        }

    }

    public func play(complete: Callback? = nil) {
        self.dispatch {
            self.delegate?.playbackDidStart()
            self.delegate?.playbackDidProgress(amount: 0.5)
            complete?(true)
        }
    }

    public func stop(complete: Callback? = nil) {
        self.dispatch {
            self.delegate?.playbackDidStop()
            self.delegate?.playbackDidProgress(amount: 0.5)
            complete?(true)
        }
    }

    private func dispatch(closure: @escaping () -> Void) {
        DispatchQueue.main.async(execute: closure)
    }

}
