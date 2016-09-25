////
////  ViewContentViewController.h
////  Tapsmash
////
////  Created by Evan Latner on 6/6/16.
////  Copyright © 2016 tapsmash. All rights reserved.
////
//
//#import <UIKit/UIKit.h>
//#import <Parse/Parse.h>
//#import "ProgressHUD.h"
//#import "Tapsmash-swift.h"
//#import <AVFoundation/AVFoundation.h>
//
//@class ViewContentViewController;
//
//@protocol ViewContentViewControllerDelegate <NSObject>
//
//-(void)disableScroll;
//-(void)enableScroll;
//
//@end
//
//
//@interface ViewContentViewController : UIViewController <UIGestureRecognizerDelegate>
//
//@property(nonatomic,weak) IBOutlet id<ViewContentViewControllerDelegate> delegate;
//
//@property (nonatomic, strong) NSMutableArray *contentArray;
//@property (nonatomic, strong) AVAsset *avAsset;
//@property (nonatomic, strong) AVURLAsset *urlAsset;
//@property (nonatomic, strong) AVPlayerItem *avPlayerItem;
//@property (nonatomic, strong) AVPlayer *avPlayer;
//@property (nonatomic, strong) AVPlayer *avPlayerTwo;
//@property (nonatomic, strong) AVAsset *avAssetTwo;
//@property (nonatomic, strong) AVURLAsset *urlAssetTwo;
//@property (nonatomic, strong) AVPlayerItem *avPlayerItemTwo;
//@property (nonatomic, strong) AVQueuePlayer *qPlayer;
//@property (nonatomic, strong) AVPlayerLayer *avPlayerLayer;
//@property (nonatomic, strong) AVPlayerLayer *avPlayerLayerTwo;
//@property (weak, nonatomic) IBOutlet UIImageView *imageView;
//@property (nonatomic, strong) UITapGestureRecognizer *tapTap;
//@property (nonatomic, strong) UIActivityIndicatorView *indicator;
//@property (strong, nonatomic) IBOutlet UILabel *subtitleLabel;
//@property (strong, nonatomic) IBOutlet UILabel *subtitleLabelTwo;
//@property (nonatomic, strong) Interactor *interactor;
//
//@property (nonatomic, strong) NSTimer *skipTimer;
//@property (nonatomic, strong) NSTimer *dasTimer;
//@property (nonatomic, strong) NSTimer *handleTapTimer;
//@property (nonatomic, strong) UIView *replayView;
//@property (nonatomic, strong) UIButton *replayButton;
//
//@property (weak, nonatomic) IBOutlet UILabel *countDownLabel;
//@property (nonatomic, strong) NSMutableArray *videoArray;
//@property (nonatomic, strong) NSMutableArray *imageArray;
//@property (weak, nonatomic) IBOutlet UIButton *flagButton;
//
//- (IBAction)flagButtonTapped:(id)sender;
