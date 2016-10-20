//
//  DefaultAudioEngine.swift
//  Pods
//
//  Created by Dan Halliday on 19/10/2016.
//
//

import Foundation
import AVFoundation

private var playerItemContext = 0

class DefaultAudioEngine: NSObject, AudioEngine {

    weak var delegate: AudioEngineDelegate?

    fileprivate let player = AVPlayer()
    fileprivate var observer: Any?

    func load(url: URL) {

        self.removeItemObserver(item: self.player.currentItem)
        let item = AVPlayerItem(url: url)
        self.addItemObserver(item: item)
        self.player.replaceCurrentItem(with: item)

    }

    func play() {
        self.addPlayerObserver(player: self.player)
        self.player.play()
    }

    func stop() {
        self.removePlayerObserver(player: self.player)
        self.player.pause()
    }

    func addItemObserver(item: AVPlayerItem?) {
        item?.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.status), options: .new, context: &playerItemContext)
    }

    func removeItemObserver(item: AVPlayerItem?) {
        item?.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.status), context: &playerItemContext)
    }

    func addPlayerObserver(player: AVPlayer) {

        let interval = CMTime(value: 1, timescale: 1)
        let queue = DispatchQueue.main

        player.addPeriodicTimeObserver(forInterval: interval, queue: queue) { time in

            if let duration = player.currentItem?.duration {
                self.delegate?.playbackDidProgress(amount: time.seconds / duration.seconds)
            }

        }

    }

    func removePlayerObserver(player: AVPlayer) {

        if let observer = self.observer {
            player.removeTimeObserver(observer)
            self.observer = nil
        }

    }

    deinit {
        self.removeItemObserver(item: self.player.currentItem)
        self.removePlayerObserver(player: self.player)
    }

}

extension DefaultAudioEngine {

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {

        guard context == &playerItemContext, keyPath == #keyPath(AVPlayerItem.status) else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            return
        }

        let status: AVPlayerItemStatus

        if let statusNumber = change?[.newKey] as? NSNumber {
            status = AVPlayerItemStatus(rawValue: statusNumber.intValue)!
        } else {
            status = .unknown
        }

        switch status {
        case .readyToPlay:
            print("readyToPlay")
            self.delegate?.loadingDidFinish()

        case .failed:
            print("failed: \(self.player.error)")
            self.delegate?.loadingDidFail()

        case .unknown:
            print("unknown: \(self.player.error)")
            self.delegate?.loadingDidFail()

        }


    }

}
