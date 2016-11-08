//
//  Remote.swift
//  Pods
//
//  Created by Dan Halliday on 08/11/2016.
//
//

public protocol Remote {

    func itemDidChange(item: RemoteItem?)

    func playbackDidStart(position: Double)
    func playbackDidStop(position: Double)

    weak var delegate: RemoteDelegate? { get set }

}

public protocol RemoteDelegate: class {

    func playCommandDidFire()
    func pauseCommandDidFire()

}

public struct RemoteItem {

    let title: String
    let author: String
    let publisher: String
    let url: URL
    let duration: Double
    let image: URL

}
