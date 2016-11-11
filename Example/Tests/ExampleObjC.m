//
//  ExampleObjC.m
//  Lstn
//
//  Created by Dan Halliday on 27/10/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

#import <XCTest/XCTest.h>

@import Lstn;

@interface ExampleObjC : NSObject <PlayerDelegate>

@property (strong) id<Player> player;

@property NSString *article;
@property NSString *publisher;

@property BOOL loading;
@property BOOL playing;
@property double progress;
@property BOOL error;

@end

@implementation ExampleObjC

- (instancetype)init {

    self = [super init];

    if (self) {

        _player = [Lstn createPlayer];

        _article = @"12345-an-article-id";
        _publisher = @"12345-a-publisher-token";

        _loading = false;
        _playing = false;
        _progress = 0.0;
        _error = false;

        _player.delegate = self;

    }

    return self;

}

- (void)loadButtonWasTapped {
    [_player loadWithArticle: self.article publisher:self.publisher];
}

- (void)playButtonWasTapped {
    [_player play];
}

- (void)stopButtonWasTapped {
    [_player stop];
}

// MARK: - Player Delegate

- (void)loadingDidStart {
    _loading = true;
    _error = false;
}

- (void)loadingDidFinish {
    _loading = false;
}

- (void)loadingDidFail {
    _loading = false;
    _error = true;
}

- (void)playbackDidStart {
    _playing = true;
    _error = false;
}

- (void)playbackDidProgressWithAmount:(double)amount {
    _progress = amount;
}

- (void)playbackDidStop {
    _playing = false;
}

- (void)playbackDidFinish {
    _playing = false;
}

- (void)playbackDidFail {
    _playing = false;
    _error = false;
}

@end
