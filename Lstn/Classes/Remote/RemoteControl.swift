//
//  RemoteControl.swift
//  Pods
//
//  Created by Dan Halliday on 08/11/2016.
//
//

protocol RemoteControl {

    func itemDidChange(item: RemoteControlItem?)

    func playbackDidStart(position: Double)
    func playbackDidStop(position: Double)

    weak var delegate: RemoteControlDelegate? { get set }

}

protocol RemoteControlDelegate: class {

    func playCommandDidFire()
    func pauseCommandDidFire()

}

struct RemoteControlItem {

    let title: String
    let author: String
    let publisher: String
    let url: URL
    let duration: Double
    let image: URL

}
