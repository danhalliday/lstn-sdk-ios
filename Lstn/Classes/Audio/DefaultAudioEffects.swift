//
//  DefaultAudioEffects.swift
//  Pods
//
//  Created by Dan Halliday on 05/12/2016.
//
//

import AudioToolbox

class DefaultAudioEffects: AudioEffects {

    private var identifiers: [AudioEffect:UInt32] = [:]

    func load() {

        self.identifiers.removeAll()

        for sound in AudioEffect.all {

            let bundle = Bundle(for: type(of: self))

            guard let path = bundle.path(forResource: sound.rawValue, ofType: nil) else {
                continue
            }

            guard let url = URL(string: path) else {
                continue
            }

            var id: SystemSoundID = 0

            AudioServicesCreateSystemSoundID((url as CFURL), &id)

            self.identifiers[sound] = id

        }

    }

    func play(_ effect: AudioEffect) {

        guard let id = self.identifiers[effect] else {
            return
        }

        AudioServicesPlaySystemSound(id)
        
    }

}
