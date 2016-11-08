//
//  MediaPlayerRemote.swift
//  Pods
//
//  Created by Dan Halliday on 08/11/2016.
//
//

import MediaPlayer
import UIKit

class MediaPlayerRemote: NSObject, Remote {

    var item: RemoteItem? = nil
    var playing: Bool = false

    weak var delegate: RemoteDelegate? = nil

    override init() {
        super.init()
        self.registerForCommands()
    }

    func itemDidChange(item: RemoteItem) {
        self.item = item
        self.updateNowPlayingInfo()
    }

    func playbackDidStart() {
        self.playing = true
        self.updateNowPlayingInfo()
    }

    func playbackDidStop() {
        self.playing = false
        self.updateNowPlayingInfo()
    }

    func nowPlayingInfo() -> [String:Any] {

        guard let item = self.item else {
            return [:]
        }

        return [
            MPMediaItemPropertyTitle: item.title,
            MPMediaItemPropertyArtist: item.author,
            MPMediaItemPropertyAlbumTitle: item.publisher,
            MPMediaItemPropertyPodcastTitle: item.publisher,
            MPMediaItemPropertyGenre: "podcast",
            MPMediaItemPropertyAssetURL: item.url.absoluteString,
            // MPMediaItemPropertyArtwork: ...
            // MPMediaItemPropertyPlaybackDuration: 100,
            // MPNowPlayingInfoPropertyElapsedPlaybackTime: 50,
            MPNowPlayingInfoPropertyPlaybackRate: self.playing ? 1 : 0
        ]
        
    }

    func updateNowPlayingInfo() {
        MPNowPlayingInfoCenter.default().nowPlayingInfo = self.nowPlayingInfo()
    }

    func registerForCommands() {

        let center = MPRemoteCommandCenter.shared()

        center.playCommand.addTarget(self, action: #selector(self.playCommandDidFire))
        center.pauseCommand.addTarget(self, action: #selector(self.pauseCommandDidFire))

    }

}

// MARK: - Remote Command Handlers

extension MediaPlayerRemote {

    @objc func playCommandDidFire() {
        self.delegate?.playCommandDidFire()
    }

    @objc func pauseCommandDidFire() {
        self.delegate?.pauseCommandDidFire()
    }


    @objc func stopCommandDidFire() {

    }

    @objc func playPauseToggleCommandDidFire() {

    }

    @objc func previousCommandDidFire() {

    }

    @objc func nextCommandDidFire() {

    }

    @objc func changePlaybackRateCommandDidFire() {

    }



}
