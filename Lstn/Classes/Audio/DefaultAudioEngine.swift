//
//  DefaultAudioEngine.swift
//  Pods
//
//  Created by Dan Halliday on 19/10/2016.
//
//

import Foundation
import AVFoundation

class DefaultAudioEngine: NSObject, AudioEngine {

    weak var delegate: AudioEngineDelegate?

    @objc fileprivate let player = AVPlayer()

    fileprivate var rateObservationContext = 0
    fileprivate var statusObservationContext = 0

    fileprivate var periodicObservers: [Any] = []

    fileprivate let queue = DispatchQueue.global(qos: .background)

    override init() {
        super.init()
        self.addPropertyObservers()
    }

    func load(url: URL) {
        self.dispatch {
            self.player.replaceCurrentItem(with: AVPlayerItem(url: url))
        }
    }

    func play() {
        self.dispatch {
            self.addPeriodicObservers()
            self.player.play()
        }
    }

    func stop() {
        self.dispatch {
            self.removePeriodicObservers()
            self.player.pause()
        }
    }

    private func dispatch(closure: @escaping () -> Void) {
        self.queue.async(execute: closure)
    }

    deinit {
        self.removePropertyObservers()
        self.removePeriodicObservers()
    }

}

// MARK: - KVO Setup

extension DefaultAudioEngine {

    fileprivate func addPropertyObservers() {

        self.player.addObserver(self, forKeyPath: #keyPath(AVPlayer.rate), options: .new, context: &rateObservationContext)
        self.player.addObserver(self, forKeyPath: #keyPath(AVPlayer.currentItem.status), options: .new, context: &statusObservationContext)

    }

    fileprivate func removePropertyObservers() {

        self.player.removeObserver(self, forKeyPath: #keyPath(AVPlayer.rate), context: &rateObservationContext)
        self.player.removeObserver(self, forKeyPath: #keyPath(AVPlayer.currentItem.status), context: &statusObservationContext)

    }

    fileprivate func addPeriodicObservers() {

        let interval = CMTime(value: 1, timescale: 1)
        let queue = DispatchQueue.main

        guard let duration = self.player.currentItem?.duration, duration.seconds > 0 else {
            return
        }

        let observer = self.player.addPeriodicTimeObserver(forInterval: interval, queue: queue) {
            time in
            self.delegate?.playbackDidProgress(amount: time.seconds / duration.seconds)
        }

        self.periodicObservers.append(observer)

    }

    fileprivate func removePeriodicObservers() {

        self.periodicObservers.forEach { self.player.removeTimeObserver($0) }
        self.periodicObservers.removeAll()

    }
    
}

// MARK: - KVO Handlers

extension DefaultAudioEngine {

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {

        switch context {

        case .some(&statusObservationContext):
            self.statusDidChange(change: change)

        case .some(&rateObservationContext):
            self.rateDidChange(change: change)

        default:
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }

    }

    private func statusDidChange(change: [NSKeyValueChangeKey: Any]?) {

        guard let number = change?[.newKey] as? NSNumber else { return }
        guard let status = AVPlayerItemStatus(rawValue: number.intValue) else { return }

        switch status {

        case .unknown:
            self.queue.async { self.delegate?.loadingDidStart() }

        case .readyToPlay:
            self.queue.async { self.delegate?.loadingDidFinish() }

        case .failed:
            self.queue.async { self.delegate?.loadingDidFail() }

        }

    }

    private func rateDidChange(change: [NSKeyValueChangeKey: Any]?) {

        guard let number = change?[.newKey] as? NSNumber else { return }

        if number.floatValue > 0 {
            self.queue.async { self.delegate?.playbackDidStart() }
        } else {
            self.queue.async { self.delegate?.playbackDidStop() }
        }

    }

}
