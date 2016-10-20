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
    private let engine: AudioEngine

    public typealias Callback = (Bool) -> Void

    fileprivate var loadCallback: Callback?

    public init(resolver: ContentResolver = RemoteContentResolver(),
                engine: AudioEngine = DefaultAudioEngine()) {

        self.resolver = resolver
        self.engine = engine

        self.engine.delegate = self

    }

    public func load(source: URL, complete: Callback? = nil) {

        self.loadCallback = complete

        self.resolver.resolve(source: source) { state in

            switch state {

            case .started:
                self.dispatch {
                    self.delegate?.loadingDidStart()
                }

            case .resolved(let content):
                self.dispatch {
                    self.engine.load(url: content.media.first!)
                }

            case .failed:
                self.dispatch {
                    self.delegate?.loadingDidFail()
                    self.loadCallback?(false)
                }

            }

        }

    }

    public func play(complete: Callback? = nil) {
        self.engine.play()
        // TODO: Callback?
    }

    public func stop(complete: Callback? = nil) {
        self.engine.stop()
        // TODO: Callback?
    }

    fileprivate func dispatch(closure: @escaping () -> Void) {
        DispatchQueue.main.async(execute: closure)
    }

}

extension Player: AudioEngineDelegate {

    public func loadingDidStart() {
        // ...
    }

    public func loadingDidFinish() {
        self.dispatch {
            self.delegate?.loadingDidFinish()
            self.loadCallback?(true)
        }
    }

    public func loadingDidFail() {
        self.dispatch {
            self.delegate?.loadingDidFail()
            self.loadCallback?(false)
        }
    }

    public func playbackDidStart() {
        self.dispatch {
            self.delegate?.playbackDidStart()
        }
    }

    public func playbackDidProgress(amount: Double) {
        self.dispatch {
//            self.delegate?.playbackDidProgress(amount: amount)
        }
    }

    public func playbackDidStop() {
        self.dispatch {
            self.delegate?.playbackDidStop()
        }
    }

    public func playbackDidFinish() {
        self.dispatch {
            self.delegate?.playbackDidFinish()
        }
    }

    public func playbackDidFail() {
        self.dispatch {
            self.delegate?.playbackDidFail()
        }
    }

}
