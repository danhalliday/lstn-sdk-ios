//
//  DefaultPlayer.swift
//  Pods
//
//  Created by Dan Halliday on 11/11/2016.
//
//

import Foundation

final class DefaultPlayer: Player {

    weak var delegate: PlayerDelegate? = nil

    fileprivate let resolver: ArticleResolver
    fileprivate let engine: AudioEngine
    fileprivate let control: RemoteControl

    fileprivate var loadCallback: PlayerCallback? = nil
    fileprivate var playCallback: PlayerCallback? = nil
    fileprivate var stopCallback: PlayerCallback? = nil

    fileprivate var article: Article? = nil
    fileprivate let queue = DispatchQueue.main

    init(resolver: ArticleResolver = RemoteArticleResolver(),
         engine: AudioEngine = DefaultAudioEngine(),
         control: RemoteControl = SystemRemoteControl()) {

        self.resolver = resolver
        self.engine = engine
        self.control = control

        self.resolver.delegate = self
        self.engine.delegate = self
        self.control.delegate = self

    }

    // MARK: - Public Methods

    func load(article: String, publisher: String) {
        self.resolver.resolve(key: ArticleKey(id: article, publisher: publisher))
    }

    func load(article: String, publisher: String, complete: @escaping PlayerCallback) {

        self.loadCallback = complete
        self.load(article: article, publisher: publisher)

    }

    func play() {
        self.engine.play()
    }

    func play(complete: @escaping PlayerCallback) {

        self.playCallback = complete
        self.play()

    }

    func stop() {
        self.engine.stop()
    }

    func stop(complete: @escaping PlayerCallback) {

        self.stopCallback = complete
        self.stop()

    }

    // MARK: - Private Methods

    fileprivate func remoteControlItemForArticle(article: Article) -> RemoteControlItem {

        return RemoteControlItem(
            title: article.title, author: article.author, publisher: article.publisher,
            url: article.source, duration: self.engine.totalTime, image: article.image
        )

    }

}

// MARK: - Article Resolver Delegate

extension DefaultPlayer: ArticleResolverDelegate {

    func resolutionDidStart(key: ArticleKey) {

        self.queue.async {
            self.delegate?.loadingDidStart()
        }

    }

    func resolutionDidFinish(key: ArticleKey, article: Article) {

        self.article = article

        self.control.itemDidChange(item: self.remoteControlItemForArticle(article: article))
        self.engine.load(url: article.audio)

    }

    func resolutionDidFail(key: ArticleKey) {

        self.queue.async {
            self.delegate?.loadingDidFail()
            self.loadCallback?(false)
            self.loadCallback = nil
        }

    }

}

// MARK: - Audio Engine Delegate

extension DefaultPlayer: AudioEngineDelegate {

    func loadingDidStart() {}

    func loadingDidFinish() {

        if let article = self.article {
            self.control.itemDidChange(item: self.remoteControlItemForArticle(article: article))
        }

        self.queue.async {
            self.delegate?.loadingDidFinish()
            self.loadCallback?(true)
            self.loadCallback = nil
        }

    }

    func loadingDidFail() {

        self.queue.async {
            self.delegate?.loadingDidFail()
            self.loadCallback?(false)
            self.loadCallback = nil
        }

    }

    func playbackDidStart() {

        self.control.playbackDidStart(position: self.engine.elapsedTime)

        self.queue.async {
            self.delegate?.playbackDidStart()
            self.playCallback?(true)
            self.playCallback = nil
        }

    }

    func playbackDidProgress(amount: Double) {

        self.queue.async {
            self.delegate?.playbackDidProgress(amount: amount)
        }

    }

    func playbackDidStop() {

        self.control.playbackDidStop(position: self.engine.elapsedTime)

        self.queue.async {
            self.delegate?.playbackDidStop()
            self.stopCallback?(true)
            self.stopCallback = nil
        }

    }

    func playbackDidFinish() {

        self.queue.async {
            self.delegate?.playbackDidFinish()
        }

    }

    func playbackDidFail() {

        self.queue.async {
            self.delegate?.playbackDidFail()
            self.playCallback?(false)
            self.playCallback = nil
        }
        
    }

}

// MARK: - Remote Control Delegate

extension DefaultPlayer: RemoteControlDelegate {

    func playCommandDidFire() {
        self.engine.play()
    }

    func pauseCommandDidFire() {
        self.engine.stop()
    }

}
