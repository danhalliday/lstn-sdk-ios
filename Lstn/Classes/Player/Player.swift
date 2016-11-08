//
//  Player.swift
//  Pods
//
//  Created by Dan Halliday on 17/10/2016.
//
//

import Foundation
import MediaPlayer

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

@objc public class Player: NSObject {

    public weak var delegate: PlayerDelegate? = nil

    fileprivate let resolver: ContentResolver
    fileprivate let engine: AudioEngine
    fileprivate let remote: Remote

    public typealias Callback = (Bool) -> Void

    fileprivate var loadCallback: Callback?

    fileprivate let queue = DispatchQueue.main

    public init(resolver: ContentResolver = RemoteContentResolver(),
                engine: AudioEngine = DefaultAudioEngine(),
                remote: Remote = MediaPlayerRemote()) {

        self.resolver = resolver
        self.engine = engine
        self.remote = remote

        super.init()

        self.engine.delegate = self
        self.remote.delegate = self

    }

    override convenience init() {
        // For Objective-C compatibility
        self.init(resolver: RemoteContentResolver(), engine: DefaultAudioEngine(), remote: MediaPlayerRemote())
    }


    public func load(source: URL, complete: Callback? = nil) {
        self.loadCallback = complete

        self.resolver.resolve(source: source) { state in

            switch state {

            case .started:
                self.queue.async {
                    self.delegate?.loadingDidStart()
                }

            case .resolved(let content):
                self.remote.itemDidChange(item: self.remoteItemForContent(content: content))
                self.engine.load(url: content.media.first!.url)

            case .failed:
                self.queue.async {
                    self.delegate?.loadingDidFail()
                    self.loadCallback?(false)
                }

            case .cancelled:
                break

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

    private func remoteItemForContent(content: Content) -> RemoteItem {
        return RemoteItem(title: content.title, author: content.author,
                          publisher: content.publisher, url: content.url)
    }

}

extension Player: AudioEngineDelegate {

    public func loadingDidStart() {
        // ...
    }

    public func loadingDidFinish() {
        self.queue.async {
            self.delegate?.loadingDidFinish()
            self.loadCallback?(true)
        }
    }

    public func loadingDidFail() {
        self.queue.async {
            self.delegate?.loadingDidFail()
            self.loadCallback?(false)
        }
    }

    public func playbackDidStart() {
        self.remote.playbackDidStart()
        self.queue.async {
            self.delegate?.playbackDidStart()
        }
    }

    public func playbackDidProgress(amount: Double) {
        self.queue.async {
            self.delegate?.playbackDidProgress(amount: amount)
        }
    }

    public func playbackDidStop() {
        self.remote.playbackDidStop()
        self.queue.async {
            self.delegate?.playbackDidStop()
        }
    }

    public func playbackDidFinish() {
        self.queue.async {
            self.delegate?.playbackDidFinish()
        }
    }

    public func playbackDidFail() {
        self.queue.async {
            self.delegate?.playbackDidFail()
        }
    }

}

extension Player: RemoteDelegate {

    public func playCommandDidFire() {
        self.engine.play()
    }

    public func pauseCommandDidFire() {
        self.engine.stop()
    }

}

// MARK: - Objective-C compatibility

extension Player {


    public func load(source: URL) {
        self.load(source: source, complete: nil)
    }

    public func play() {
        self.play(complete: nil)
    }

    public func stop() {
        self.stop(complete: nil)
    }

}
