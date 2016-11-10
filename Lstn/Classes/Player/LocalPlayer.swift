//
//  LocalPlayer.swift
//  Pods
//
//  Created by Dan Halliday on 10/11/2016.
//
//

import Foundation

class LocalPlayer: NSObject, Player {

    public weak var delegate: PlayerDelegate? = nil

    fileprivate let resolver: ArticleResolver
    fileprivate let engine: AudioEngine
    fileprivate let control: RemoteControl

    fileprivate var loadCallback: PlayerCallback?
    fileprivate var playCallback: PlayerCallback?
    fileprivate var stopCallback: PlayerCallback?

    fileprivate let queue = DispatchQueue.main

    fileprivate var article: Article? = nil

    public init(resolver: ArticleResolver = RemoteArticleResolver(),
                engine: AudioEngine = DefaultAudioEngine(),
                control: RemoteControl = SystemRemoteControl()) {

        self.resolver = resolver
        self.engine = engine
        self.control = control

        super.init()

        self.resolver.delegate = self
        self.engine.delegate = self
        self.control.delegate = self

    }

    override convenience init() {
        // For Objective-C compatibility
        self.init(resolver: RemoteArticleResolver(), engine: DefaultAudioEngine(), control: SystemRemoteControl())
    }

    func load(source: URL, complete: PlayerCallback? = nil) {

        self.loadCallback = complete
        self.resolver.resolve(key: ArticleKey(id: "123", publisher: "456"))

    }

    func play(complete: PlayerCallback? = nil) {

        self.playCallback = complete
        self.engine.play()

    }

    func stop(complete: PlayerCallback? = nil) {

        self.stopCallback = complete
        self.engine.stop()

    }

    fileprivate func dispatch(closure: @escaping () -> Void) {
        DispatchQueue.main.async(execute: closure)
    }

    fileprivate func remoteItemForArticle(article: Article?) -> RemoteControlItem? {

        guard let article = article else {
            return nil
        }

        return RemoteControlItem(
            title: article.title, author: article.author, publisher: article.publisher,
            url: article.source, duration: self.engine.totalTime, image: article.image
        )

    }

}

extension LocalPlayer: ArticleResolverDelegate {

    public func resolutionDidStart(key: ArticleKey) {
        self.delegate?.loadingDidStart()
    }

    public func resolutionDidFinish(key: ArticleKey, article: Article) {

        self.control.itemDidChange(item: self.remoteItemForArticle(article: article))

        self.article = article
        self.engine.load(url: article.audio)

    }

    public func resolutionDidFail(key: ArticleKey) {

        self.delegate?.loadingDidFail()
        self.loadCallback?(false)

    }

}

extension LocalPlayer: AudioEngineDelegate {

    func loadingDidStart() {
        // ...
    }

    func loadingDidFinish() {

        self.control.itemDidChange(item: self.remoteItemForArticle(article: self.article))

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

extension LocalPlayer: RemoteControlDelegate {

    func playCommandDidFire() {
        self.engine.play()
    }

    func pauseCommandDidFire() {
        self.engine.stop()
    }

}

// MARK: - Objective-C compatibility
//
//    extension LocalPlayer {
//
//
//        func load(source: URL) {
//            self.load(source: source, complete: nil)
//        }
//        
//        func play() {
//            self.play(complete: nil)
//        }
//        
//        func stop() {
//            self.stop(complete: nil)
//        }
//        
//    }
