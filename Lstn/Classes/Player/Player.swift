//
//  Player.swift
//  Pods
//
//  Created by Dan Halliday on 17/10/2016.
//
//

import Foundation
import MediaPlayer

@objc public protocol PlayerDelegate: class {

    func loadingDidStart()
    func loadingDidFinish()
    func loadingDidFail()

    func playbackDidStart()
    func playbackDidProgress(amount: Double)
    func playbackDidStop()
    func playbackDidFinish()
    func playbackDidFail()

}

@objc public class Player: NSObject {

    public weak var delegate: PlayerDelegate? = nil

    fileprivate let resolver: ArticleResolver
    fileprivate let engine: AudioEngine
    fileprivate let remote: Remote

    public typealias Callback = (Bool) -> Void

    fileprivate var loadCallback: Callback?

    fileprivate let queue = DispatchQueue.main

    fileprivate var article: Article? = nil

    public init(resolver: ArticleResolver = RemoteArticleResolver(),
                engine: AudioEngine = DefaultAudioEngine(),
                remote: Remote = MediaPlayerRemote()) {

        self.resolver = resolver
        self.engine = engine
        self.remote = remote

        super.init()

        self.resolver.delegate = self
        self.engine.delegate = self
        self.remote.delegate = self

    }

    override convenience init() {
        // For Objective-C compatibility
        self.init(resolver: RemoteArticleResolver(), engine: DefaultAudioEngine(), remote: MediaPlayerRemote())
    }

    public func load(source: URL, complete: Callback? = nil) {
        self.loadCallback = complete
        self.resolver.resolve(key: ArticleKey(id: "123", publisher: "456"))
    }

    public func play(complete: Callback? = nil) {
        self.engine.play()
        // TODO: Callback?
    }

    public func stop(complete: Callback? = nil) {
        self.engine.stop()
        // TODO: Callback?
    }

    fileprivate func dispatch(closure: @escaping () -> Void) {
        DispatchQueue.main.async(execute: closure)
    }

    fileprivate func remoteItemForArticle(article: Article?) -> RemoteItem? {

        guard let article = article else {
            return nil
        }

        return RemoteItem(title: article.title, author: article.author,
                          publisher: article.publisher, url: article.source,
                          duration: self.engine.totalTime, image: article.image)

    }

}

extension Player: ArticleResolverDelegate {

    public func resolutionDidStart(key: ArticleKey) {
        self.delegate?.loadingDidStart()
    }

    public func resolutionDidFinish(key: ArticleKey, article: Article) {
        self.remote.itemDidChange(item: self.remoteItemForArticle(article: article))
        self.article = article
    }

    public func resolutionDidFail(key: ArticleKey) {
        self.delegate?.loadingDidFail()
        self.loadCallback?(false)
    }

}

extension Player: AudioEngineDelegate {

    public func loadingDidStart() {
        // ...
    }

    public func loadingDidFinish() {
        self.remote.itemDidChange(item: self.remoteItemForArticle(article: self.article))
        self.queue.async {
            self.delegate?.loadingDidFinish()
            self.loadCallback?(true)
        }
    }

    public func loadingDidFail() {
        self.queue.async {
            self.delegate?.loadingDidFail()
            self.loadCallback?(false)
        }
    }

    public func playbackDidStart() {
        self.remote.playbackDidStart(position: self.engine.elapsedTime)
        self.queue.async {
            self.delegate?.playbackDidStart()
        }
    }

    public func playbackDidProgress(amount: Double) {
        self.queue.async {
            self.delegate?.playbackDidProgress(amount: amount)
        }
    }

    public func playbackDidStop() {
        self.remote.playbackDidStop(position: self.engine.elapsedTime)
        self.queue.async {
            self.delegate?.playbackDidStop()
        }
    }

    public func playbackDidFinish() {
        self.queue.async {
            self.delegate?.playbackDidFinish()
        }
    }

    public func playbackDidFail() {
        self.queue.async {
            self.delegate?.playbackDidFail()
        }
    }

}

extension Player: RemoteDelegate {

    public func playCommandDidFire() {
        self.engine.play()
    }

    public func pauseCommandDidFire() {
        self.engine.stop()
    }

}

// MARK: - Objective-C compatibility

extension Player {


    public func load(source: URL) {
        self.load(source: source, complete: nil)
    }

    public func play() {
        self.play(complete: nil)
    }

    public func stop() {
        self.stop(complete: nil)
    }

}
