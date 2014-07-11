//
//  WTViewController.m
//  sandbox
//
//  Created by Wito Chandra on 6/12/14.
//  Copyright (c) 2014 Wito Chandra. All rights reserved.
//

#import "WTYoutubeViewController.h"

#import <YTPlayerView.h>

@interface WTYoutubeViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, YTPlayerViewDelegate>

@property (nonatomic, weak) IBOutlet YTPlayerView *playerView;

@end

@implementation WTYoutubeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.playerView.delegate = self;
    [self.playerView loadWithVideoId:@"RnCPuWqToPA" playerVars:@{
            @"playsinline" : @1,
            @"fs": @0,
            @"autoplay": @1
    }];
    [self.playerView playVideo];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

#pragma mark - YTPlayerViewDelegate
- (void)playerViewDidBecomeReady:(YTPlayerView *)playerView
{
    NSLog(@"player did become ready");
}

- (void)playerView:(YTPlayerView *)playerView didChangeToQuality:(YTPlaybackQuality)quality
{
    NSLog(@"Change to quality %i", quality);
}

- (void)playerView:(YTPlayerView *)playerView didChangeToState:(YTPlayerState)state
{
    NSLog(@"Change to state %i", state);
}

- (void)playerView:(YTPlayerView *)playerView receivedError:(YTPlayerError)error
{
    NSLog(@"Error %i", error);
}

@end
