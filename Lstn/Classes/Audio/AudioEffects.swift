//
//  AudioEffects.swift
//  Pods
//
//  Created by Dan Halliday on 05/12/2016.
//
//

import UIKit
import AudioToolbox

protocol AudioEffects {

    func load()
    func play(_ effect: AudioEffect)

}

enum AudioEffect: String {

    case bong = "Bong.wav"

    static let all = [bong]

}
