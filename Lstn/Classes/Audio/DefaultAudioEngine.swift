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

    fileprivate var timeObservers: [Any] = []

    fileprivate let queue = DispatchQueue.global(qos: .background)

    override init() {
        super.init()
        self.addPlayerObservers(player: self.player)
    }

    func load(url: URL) {
        self.queue.async {
            self.removeItemObservers(item: self.player.currentItem)
            let item = AVPlayerItem(url: url)
            self.addItemObservers(item: item)
            self.player.replaceCurrentItem(with: item)
        }
    }

    func play() {
        self.queue.async {
            self.addPlayerTimeObservers(player: self.player)
            self.player.play()
        }
    }

    func stop() {
        self.queue.async {
            self.removePlayerTimeObservers(player: self.player)
            self.player.pause()
        }
    }

    deinit {
        self.removePlayerObservers(player: self.player)
        self.removePlayerTimeObservers(player: self.player)
    }

}

// MARK: - KVO Setup

extension DefaultAudioEngine {

    fileprivate func addPlayerObservers(player: AVPlayer) {

        player.addObserver(self, forKeyPath: #keyPath(AVPlayer.rate), options: .new, context: &rateObservationContext)
        player.addObserver(self, forKeyPath: #keyPath(AVPlayer.currentItem.status), options: .new, context: &statusObservationContext)

    }

    fileprivate func removePlayerObservers(player: AVPlayer) {

        player.removeObserver(self, forKeyPath: #keyPath(AVPlayer.rate), context: &rateObservationContext)
        player.removeObserver(self, forKeyPath: #keyPath(AVPlayer.currentItem.status), context: &statusObservationContext)

    }

    fileprivate func addPlayerTimeObservers(player: AVPlayer) {

        let interval = CMTime(value: 1, timescale: 1)
        let queue = DispatchQueue.main

        guard let duration = player.currentItem?.duration, duration.seconds > 0 else {
            return
        }

        let observer = player.addPeriodicTimeObserver(forInterval: interval, queue: queue) {
            time in self.delegate?.playbackDidProgress(amount: time.seconds / duration.seconds)
        }

        self.timeObservers.append(observer)

    }

    fileprivate func removePlayerTimeObservers(player: AVPlayer) {

        self.timeObservers.forEach { player.removeTimeObserver($0) }
        self.timeObservers.removeAll()
        
    }

    fileprivate func addItemObservers(item: AVPlayerItem?) {
        NotificationCenter.default.addObserver(self, selector: #selector(self.playbackDidFinish), name: .AVPlayerItemDidPlayToEndTime, object: item)
    }

    fileprivate func removeItemObservers(item: AVPlayerItem?) {
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: item)
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
            self.delegate?.loadingDidStart()

        case .readyToPlay:
            self.delegate?.loadingDidFinish()

        case .failed:
            print("Audio engine failed to load: \(self.player.error)")
            print("Player item error: \(self.player.currentItem?.error)")
            self.delegate?.loadingDidFail()

        }

    }

    private func rateDidChange(change: [NSKeyValueChangeKey: Any]?) {

        guard let number = change?[.newKey] as? NSNumber else { return }

        if number.floatValue > 0 {
            self.delegate?.playbackDidStart()
        } else {
            self.delegate?.playbackDidStop()
        }

    }

}

// MARK: - Notification Handlers

extension DefaultAudioEngine {

    @objc func playbackDidFinish() {
        self.delegate?.playbackDidFinish()
    }

}
