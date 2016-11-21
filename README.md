# 🎙 Lstn

[![CI Status](http://img.shields.io/travis/lstn-ltd/lstn-sdk-ios.svg)](https://travis-ci.org/lstn-ltd/lstn-sdk-ios)
[![Version](https://img.shields.io/cocoapods/v/Lstn.svg)](http://cocoapods.org/pods/Lstn)
[![License](https://img.shields.io/cocoapods/l/Lstn.svg)](http://cocoapods.org/pods/Lstn)
[![Platform](https://img.shields.io/cocoapods/p/Lstn.svg)](http://cocoapods.org/pods/Lstn)

Lstn is a podcast player for your app’s text content.

## Installation

Lstn is available through [CocoaPods](http://cocoapods.org). To install it, simply add the following line to your Podfile:

```ruby
pod "Lstn"
```

Lstn requires a token to use the service. [Get in touch](mailto:hello@lstn.ltd) with us to receive one, and then add it to your app’s `Info.plist` file under the `LstnToken` key:

![Setting Lstn’s token property list entry in Xcode](https://s12.postimg.org/67om5j7wd/lstn_info_variables_xcode.png)

You may also override the token value in `Info.plist` using an environment variable under the `LSTN_TOKEN` key:

![Setting Lstn’s token environemnt variable in Xcode](https://s12.postimg.org/w0r3beg6l/lstn_environment_variables_xcode.png)

You probably also want to enable audio playback when your app is in the background. Check the _audio, airplay, and picture in picture_ background mode in the _capabilities_ tab for your app target in Xcode:

![Enabling your app to play audio when in the background](https://s11.postimg.org/waf9ljgmb/lstn_background_modes_xcode.png)

## Quick Start

Lstn provides a singleton instance and simple callback interface for quick and dirty use. To load and play some content:

```swift
let article = "12345-an-article-id"
let publisher = "12345-a-publisher-id"

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
    let publisher = "12345-a-publisher-id"

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

The above can be found in Lstn’s test suite, along with an equivalent Objective-C example:

- Swift [example](https://github.com/lstn-ltd/lstn-sdk-ios/blob/master/Example/Tests/Example.swift)
- Objective-C [example](https://github.com/lstn-ltd/lstn-sdk-ios/blob/master/Example/Tests/ExampleObjC.m)

For more concrete examples, see the working [example app](https://github.com/lstn-ltd/lstn-sdk-ios/tree/master/Example) at:

- [Player View](https://github.com/lstn-ltd/lstn-sdk-ios/blob/master/Example/Lstn/PlayerView.swift) is a simple `UIView` which controls and reacts to Lstn’s shared player
- [Articles Controller](https://github.com/lstn-ltd/lstn-sdk-ios/blob/master/Example/Lstn/ArticlesController.swift) is a simple `UIViewController` which fetches articles from a Lstn-compatible source and plays those articles with Lstn’s shared player

For use with React Native, example bridging code can be found in Lstn’s public demo app:

- React Native [example](https://github.com/lstn-ltd/lstn-app/blob/master/ios/Lstn/PlayerBridge.m)

---

Lstn is available under the MIT license. See the LICENSE file for more info.
