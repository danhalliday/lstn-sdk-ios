//
//  DefaultAudioEffects.swift
//  Pods
//
//  Created by Dan Halliday on 05/12/2016.
//
//

import AVFoundation

class DefaultAudioEffects: AudioEffects {

    private var players: [AudioEffect:AVAudioPlayer] = [:]

    func load() {

        self.players.removeAll()

        for sound in AudioEffect.all {

            let bundle = Bundle(for: type(of: self))

            guard let path = bundle.path(forResource: sound.rawValue, ofType: nil) else {
                continue
            }

            guard let url = URL(string: path) else {
                continue
            }

            let player: AVAudioPlayer

            do { player = try AVAudioPlayer(contentsOf: url) } catch {
                continue
            }

            player.prepareToPlay()
            self.players[sound] = player

        }

    }

    func play(_ effect: AudioEffect) {

        guard let player = self.players[effect] else {
            return
        }

        player.play()

    }

}
