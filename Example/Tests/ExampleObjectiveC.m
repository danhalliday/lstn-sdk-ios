//
//  ExampleObjectiveC.m
//  Lstn
//
//  Created by Dan Halliday on 27/10/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

#import <XCTest/XCTest.h>

@import Lstn;

@interface ExampleObjectiveC : NSObject <PlayerDelegate>

@property Player *player;
@property NSURL *article;

@property BOOL loading;
@property BOOL playing;
@property double progress;
@property BOOL error;

@end

@implementation ExampleObjectiveC

- (instancetype)init {

    self = [super init];

    if (self) {

        _player = [[Lstn shared] player];
        _article = [[NSURL alloc] initWithString:@"https://example.com/article.html"];

        _loading = false;
        _playing = false;
        _progress = 0.0;
        _error = false;

        _player.delegate = self;

    }

    return self;

}

- (void)loadButtonWasTapped {
    [_player loadWithSource:_article];
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
