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

    @objc fileprivate var player = AVPlayer()

    fileprivate var rateObservationContext = 0
    fileprivate var statusObservationContext = 0

    fileprivate var timeObservers: [Any] = []

    fileprivate let queue = DispatchQueue.global(qos: .background)
    fileprivate var url: URL? = nil

    override init() {
        super.init()
        self.addPlayerObservers(player: self.player)
    }

    func load(url: URL) {

        self.queue.async {

            self.url = url

            if self.player.currentItem?.error != nil {
                self.reset()
            }

            let asset = AVURLAsset(url: url)

            asset.loadValuesAsynchronously(forKeys: ["duration"]) {

                self.queue.async {

                    if asset.url != self.url { return }

                    self.removeItemObservers(item: self.player.currentItem)
                    self.player.replaceCurrentItem(with: AVPlayerItem(asset: asset))
                    self.addItemObservers(item: self.player.currentItem)

                }

            }

        }

    }

    func play() {

        self.queue.async {

            self.enableAudioSession()
            self.removePlayerTimeObservers(player: self.player)
            self.addPlayerTimeObservers(player: self.player)

            if self.playerIsAtEnd(player: self.player) {
                self.player.seek(to: kCMTimeZero)
            }

            self.player.play()

        }

    }

    func stop() {

        self.queue.async {

            self.player.pause()

            self.removePlayerTimeObservers(player: self.player)
            self.disableAudioSession()

        }

    }

    func toggle() {

        self.queue.async {

            switch self.isPlaying {
            case true: self.stop()
            case false: self.play()
            }

        }

    }

    var elapsedTime: Double {
        return self.player.currentTime().seconds
    }

    var totalTime: Double {
        return self.player.currentItem?.duration.seconds ?? 0
    }

    var isPlaying: Bool {
        return self.player.rate > 0
    }

    private func reset() {

        self.removePlayerObservers(player: self.player)
        self.removePlayerTimeObservers(player: self.player)

        self.player = AVPlayer()

        self.addPlayerObservers(player: self.player)

    }

    private func playerIsAtEnd(player: AVPlayer) -> Bool {
        guard let item = player.currentItem else { return false }
        return player.currentTime() == item.duration
    }

    deinit {
        self.disableAudioSession()
        self.removePlayerObservers(player: self.player)
        self.removePlayerTimeObservers(player: self.player)
    }

}

// MARK: - Audio Session

extension DefaultAudioEngine {

    func enableAudioSession() {

        let session = AVAudioSession.sharedInstance()

        do { try session.setActive(true) } catch {
            print(error)
        }

        do { try session.setCategory(AVAudioSessionCategoryPlayback) } catch {
            print(error)
        }

        do { try session.setMode(AVAudioSessionModeSpokenAudio) } catch {
            print(error)
        }

        self.addAudioSessionObservers()

    }

    func disableAudioSession() {

        let session = AVAudioSession.sharedInstance()

        do { try session.setActive(false) } catch {
            print(error)
        }

        self.removeAudioSessionObservers()

    }

    func addAudioSessionObservers() {

        NotificationCenter.default.addObserver(self,
            selector: #selector(self.handleAudioSessionInterruptionEvent),
            name: Notification.Name.AVAudioSessionInterruption, object: nil)

    }

    func removeAudioSessionObservers() {

        NotificationCenter.default.removeObserver(self,
            name: Notification.Name.AVAudioSessionInterruption, object: nil)

    }

    func handleAudioSessionInterruptionEvent(notification: Notification) {

        if notification.name != Notification.Name.AVAudioSessionInterruption {
            return
        }

        guard let info = notification.userInfo else {
            return
        }

        guard let event = info[AVAudioSessionInterruptionTypeKey] as? UInt else {
            return
        }

        guard let value = AVAudioSessionInterruptionType(rawValue: event) else {
            return
        }

        switch value {
        case .began: break // TODO: Customise interrupt behaviour
        case .ended: break // TODO: Customise interrupt behaviour
        }

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

        guard let duration = player.currentItem?.duration, duration.seconds > 0 else {
            return
        }

        let observer = player.addPeriodicTimeObserver(forInterval: interval, queue: self.queue) {
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
        self.removePlayerTimeObservers(player: self.player)
        self.delegate?.playbackDidFinish()
    }

}
