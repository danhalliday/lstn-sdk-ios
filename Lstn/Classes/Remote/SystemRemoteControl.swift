//
//  SystemRemoteControl.swift
//  Pods
//
//  Created by Dan Halliday on 10/11/2016.
//
//

import UIKit
import MediaPlayer

class SystemRemoteControl: NSObject, RemoteControl {

    var item: RemoteControlItem? = nil

    var playing: Bool = false
    var position: Double = 0

    var artwork: MPMediaItemArtwork? = nil

    weak var delegate: RemoteControlDelegate? = nil

    override init() {
        super.init()
        self.registerForCommands()
    }

    func itemDidChange(item: RemoteControlItem?) {

        self.item = item

        self.updateNowPlayingInfo()
        self.updateImage(image: item?.image)

    }

    func playbackDidStart(position: Double) {

        self.playing = true
        self.position = position

        self.updateNowPlayingInfo()

    }

    func playbackDidStop(position: Double) {

        self.playing = false
        self.position = position

        self.updateNowPlayingInfo()

    }

    func nowPlayingInfo(item: RemoteControlItem) -> [String:Any] {

        var info: [String:Any] = [
            MPMediaItemPropertyTitle: item.title,
            MPMediaItemPropertyArtist: item.author,
            MPMediaItemPropertyAlbumTitle: item.publisher,
            MPMediaItemPropertyPodcastTitle: item.publisher,
            MPMediaItemPropertyGenre: "podcast",
            MPMediaItemPropertyAssetURL: item.url.absoluteString,
            MPMediaItemPropertyPlaybackDuration: item.duration,
            MPNowPlayingInfoPropertyPlaybackRate: self.playing ? 1 : 0,
            MPNowPlayingInfoPropertyElapsedPlaybackTime: self.position
        ]

        if let artwork = self.artwork {
            info[MPMediaItemPropertyArtwork] = artwork
        }

        return info

    }

    func updateNowPlayingInfo() {

        guard let item = self.item else {
            return
        }

        MPNowPlayingInfoCenter.default().nowPlayingInfo = self.nowPlayingInfo(item: item)

    }

    func registerForCommands() {

        let center = MPRemoteCommandCenter.shared()

        center.playCommand.addTarget(self, action: #selector(self.playCommandDidFire))
        center.pauseCommand.addTarget(self, action: #selector(self.pauseCommandDidFire))
        center.stopCommand.addTarget(self, action: #selector(self.stopCommandDidFire))
        center.nextTrackCommand.addTarget(self, action: #selector(self.nextCommandDidFire))
        center.previousTrackCommand.addTarget(self, action: #selector(self.previousCommandDidFire))

    }

    private func updateImage(image: URL?) {

        guard let image = image else { return }

        DispatchQueue.global(qos: .background).async {

            let data: Data

            do { data = try Data(contentsOf: image) } catch {
                return
            }

            guard let image = UIImage(data: data) else {
                return
            }

            let artwork = MPMediaItemArtwork(boundsSize: CGSize(width: 120, height: 120)) { size in
                return image
            }

            self.artwork = artwork
            self.updateNowPlayingInfo()

        }
    }

}

// MARK: - Remote Command Handlers

extension SystemRemoteControl {

    @objc func playCommandDidFire() {
        self.delegate?.playCommandDidFire()
    }

    @objc func pauseCommandDidFire() {
        self.delegate?.pauseCommandDidFire()
    }


    @objc func stopCommandDidFire() {
        self.delegate?.pauseCommandDidFire()
    }
    
    @objc func playPauseToggleCommandDidFire() {
        // TODO: Implement play/pause toggle logic
    }
    
    @objc func previousCommandDidFire() {
        self.delegate?.previousCommandDidFire()
    }
    
    @objc func nextCommandDidFire() {
        self.delegate?.nextCommandDidFire()
    }
    
    @objc func changePlaybackRateCommandDidFire() {
        // TODO: Implement rate change logic
    }

}
