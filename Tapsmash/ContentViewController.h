//
//  ContentViewController.h
//  Tapsmash
//
//  Created by Evan Latner on 11/17/15.
//  Copyright © 2015 tapsmash. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <WebKit/WebKit.h>
#import <AVFoundation/AVFoundation.h>
#import "YTPlayerView.h"

@interface ContentViewController : UIViewController <YTPlayerViewDelegate, UIWebViewDelegate, WKNavigationDelegate>


@property (nonatomic, strong) WKWebView *webview;
@property (strong, nonatomic) IBOutlet YTPlayerView *playerView;
@property (nonatomic, strong) AVAsset *avAsset;
@property (nonatomic, strong) AVURLAsset *urlAsset;
@property (nonatomic, strong) AVPlayerItem *avPlayerItem;
@property (nonatomic, strong) AVPlayer *avPlayer;
@property (nonatomic, strong) AVQueuePlayer *qPlayer;
@property (nonatomic, strong) AVPlayerLayer *avPlayerLayer;
@property (nonatomic, strong) NSTimer *dasTimer;
@property (nonatomic, strong) UITapGestureRecognizer *tapTap;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIActivityIndicatorView *indicator;


@property (nonatomic, strong) NSMutableArray *contentArray;
@property (nonatomic, strong) NSMutableArray *videoArray;
@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, strong) NSMutableArray *viewedPosts;

@property (weak, nonatomic) IBOutlet UILabel *contentCountLabel;

@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;

@property (nonatomic, strong) UIWebView *regWebview;

@property (nonatomic, strong) UIButton *replayButton;

@property (weak, nonatomic) IBOutlet UIImageView *bottomFade;

@property (weak, nonatomic) IBOutlet UIButton *likeButton;


@end
