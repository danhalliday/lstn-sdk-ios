# 🎙 Lstn

[![CI Status](http://img.shields.io/travis/lstn-ltd/lstn-sdk-ios.svg)](https://travis-ci.org/lstn-ltd/lstn-sdk-ios)
[![Version](https://img.shields.io/cocoapods/v/Lstn.svg)](http://cocoapods.org/pods/Lstn)
[![License](https://img.shields.io/cocoapods/l/Lstn.svg)](http://cocoapods.org/pods/Lstn)
[![Platform](https://img.shields.io/cocoapods/p/Lstn.svg)](http://cocoapods.org/pods/Lstn)

Lstn is a podcast player for your app’s text content.

## Getting Started

Lstn is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "Lstn"
```

Lstn provides a singleton instance and simple callback interface for quick and dirty use. To load and play some content:

```swift
let article = "12345-an-article-id"
let publisher = "12345-a-publisher-token"

Lstn.shared.player.load(article: article, publisher: publisher) { success in
    if success { Lstn.shared.player.play() }
}
```

## Real-World Example

Larger apps will need a clean way to catch all player events, so a delegate protocol (`PlayerDelegate`) is provided. You can also create your own `Player` instances as needed using the `createPlayer()` factory method:

```swift
import Lstn

class Example {

    let player = Lstn.createPlayer()

    let article = "12345-an-article-id"
    let publisher = "12345-a-publisher-token"

    var loading = false
    var playing = false
    var progress = 0.0
    var error = false

    init() {
        self.player.delegate = self
    }

    func loadButtonWasTapped() {
        self.player.load(article: self.article, publisher: self.publisher)
    }

    func playButtonWasTapped() {
        self.player.play()
    }

    func stopButtonWasTapped() {
        self.player.stop()
    }

}

extension Example: PlayerDelegate {

    func loadingDidStart() {
        self.loading = true
        self.error = false
    }

    func loadingDidFinish() {
        self.loading = false
    }

    func loadingDidFail() {
        self.loading = false
        self.error = true
    }

    func playbackDidStart() {
        self.playing = true
        self.error = false
    }

    func playbackDidProgress(amount: Double) {
        self.progress = amount
    }

    func playbackDidStop() {
        self.playing = false
    }

    func playbackDidFinish() {
        self.playing = false
    }

    func playbackDidFail() {
        self.playing = false
        self.error = true
    }

}
```

---

Lstn is available under the MIT license. See the LICENSE file for more info.
