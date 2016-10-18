# Lstn

[![CI Status](http://img.shields.io/travis/lstn-ltd/lstn-sdk-ios.svg)](https://travis-ci.org/lstn-ltd/lstn-sdk-ios)
[![Version](https://img.shields.io/cocoapods/v/Lstn.svg)](http://cocoapods.org/pods/Lstn)
[![License](https://img.shields.io/cocoapods/l/Lstn.svg)](http://cocoapods.org/pods/Lstn)
[![Platform](https://img.shields.io/cocoapods/p/Lstn.svg)](http://cocoapods.org/pods/Lstn)

Lstn is a podcast player for your app’s text content.

## Installation

Lstn is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "Lstn"
```

## Quick Start

Lstn provides a singleton instance and simple callback interface for quick and dirty use. To load some content and
play it:

```swift
import Lstn

let article = URL(string: "https://example.com/article.html")!

Lstn.shared.player.load(source: article) { success in
    if success { print("Content was loaded") }
}

Lstn.shared.player.play { success in
    if success { print("Content started playing") }
}

Lstn.shared.player.stop { success in
    if success { print("Content stopped playing") }
}
```

For more advanced use, a delegate protocol is provided:

```swift
import Lstn

class Example {

    let player = Lstn.Player()
    let url = URL(string: "https://example.com/article.html")!

    var loading = false
    var playing = false
    var progress = 0.0
    var error = false

    init() {
        self.player.delegate = self
    }

    func loadButtonWasTapped() {
        self.player.load(self.url)
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
