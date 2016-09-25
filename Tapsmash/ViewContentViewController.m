////
////  ViewContentViewController.m
////  Tapsmash
////
////  Created by Evan Latner on 6/6/16.
////  Copyright © 2016 tapsmash. All rights reserved.
////
//
//#import "ViewContentViewController.h"
//#import "SDWebImageManager.h"
////#import "SharkfoodMuteSwitchDetector.h"
//#import "AppDelegate.h"
//
//@interface ViewContentViewController ()
//
//@property BOOL replayViewShowing;
//@property BOOL currentlyQuerying;
//@property BOOL firstObjectVideo;
//@property (nonatomic, strong) NSMutableArray *updatedVideoArray;
//@property (nonatomic, strong) UIView *playerOneView;
//@property (nonatomic, strong) UIView *playerTwoView;
//@property (nonatomic, strong) SDWebImageManager *manager;
//@property (nonatomic, strong) NSMutableArray *playerItemArray;
//@property (nonatomic) BOOL playerOneReady;
//@property (nonatomic) BOOL playerTwoReady;
//@property (nonatomic) BOOL controllerIsDismissing;
//
//@property (nonatomic, strong) AppDelegate *appDelegate;
//
//@end
//
//@implementation ViewContentViewController
//
//int currentIndex;
//int skipIndex;
//int skipCount;
//int tempIndex;
//int videoCount;
//int imageCount;
//int currentSkipCount;
//int canSkip;
//
//static void* CurrentItemObservationContext = &CurrentItemObservationContext;
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    
//    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    //self.appDelegate.hasViewedStory = TRUE;
//    
//    _controllerIsDismissing = FALSE;
//    
////    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
////        
////        [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategorySoloAmbient error:nil];
////        
////        self.detector = [SharkfoodMuteSwitchDetector shared];
////        __weak ViewContentViewController* sself = self;
////        self.detector.silentNotify = ^(BOOL silent){
////            if (silent) {
////                [sself.avPlayer setVolume:0.0];
////                [sself.avPlayerTwo setVolume:0.0];
////            } else {
////                [sself.avPlayer setVolume:1.0];
////                [sself.avPlayer setVolume:1.0];
////            }
////        };
////    });
//    
//    self.manager = [SDWebImageManager sharedManager];
//    
//    _firstObjectVideo = NO;
//    
//    [self performSelector:@selector(queryForMedia) withObject:nil afterDelay:0.245];
//    
//    self.view.backgroundColor = [UIColor colorWithRed:0.33 green:0.51 blue:0.68 alpha:1.0];
//    
//    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(goHome:)];
//    swipe.direction = UISwipeGestureRecognizerDirectionDown;
//    
//    //[self.view addGestureRecognizer:swipe];
//    
////    self.yzBaby = [[YZSwipeBetweenViewController alloc] init];
////    self.delegate = self.yzBaby;
//    
//    self.subtitleLabel = [[UILabel alloc] init];
//    
//    if([UIScreen mainScreen].bounds.size.height < 568.0) {
//        self.subtitleLabel.frame = CGRectMake(0,-40, self.view.frame.size.width, 38.3);
//        [self.subtitleLabel setFont:[UIFont fontWithName:@"AvenirNext-Medium" size:16]];
//    }
//    else if([UIScreen mainScreen].bounds.size.height == 568.0) {
//        self.subtitleLabel.frame = CGRectMake(0,-40, self.view.frame.size.width, 38.3);
//        [self.subtitleLabel setFont:[UIFont fontWithName:@"AvenirNext-Medium" size:16]];
//        
//    } else if ([UIScreen mainScreen].bounds.size.height == 667.0) {
//        self.subtitleLabel.frame = CGRectMake(0,-40, self.view.frame.size.width, 39.5);
//        [self.subtitleLabel setFont:[UIFont fontWithName:@"AvenirNext-Medium" size:16.95]];
//        
//    } else  if ([UIScreen mainScreen].bounds.size.height == 736.0) {
//        self.subtitleLabel.frame = CGRectMake(0,-42, self.view.frame.size.width, 42);
//        [self.subtitleLabel setFont:[UIFont fontWithName:@"AvenirNext-Medium" size:17.75]];
//    }
//    
//    self.subtitleLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.565];
//    self.subtitleLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.995];
//    self.subtitleLabel.textAlignment = NSTextAlignmentCenter;
//    //[self.subtitleLabel setFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:16]];
//    
//    [self.view addSubview:self.subtitleLabel];
//    
//    self.subtitleLabel.hidden = YES;
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(methodToShowViewOnTop)
//                                                 name:UIApplicationDidEnterBackgroundNotification object:nil];
//    
//    UIColor *tintColor = [UIColor lightGrayColor];
//    [[UISlider appearance] setMinimumTrackTintColor:tintColor];
//        
//    self.flagButton.hidden = YES;
//    
//    [self tryThis];
//    
//    self.playerTwoView = [[UIView alloc] initWithFrame:self.view.frame];
//    self.avPlayerTwo = [[AVPlayer alloc] init];
//    //[self.avPlayerTwo addObserver:self forKeyPath:@"currentItem" options:NSKeyValueObservingOptionNew context:CurrentItemObservationContext];
//    //[self.avPlayerTwo addObserver:self forKeyPath:@"status" options:0 context:nil];
//    self.avPlayerLayerTwo = [AVPlayerLayer playerLayerWithPlayer: self.avPlayerTwo];
//    self.avPlayerLayerTwo.frame = self.view.layer.bounds;
//    self.avPlayerLayerTwo.videoGravity = AVLayerVideoGravityResizeAspectFill;
//    [self.playerTwoView.layer addSublayer:self.avPlayerLayerTwo];
//    [self.view addSubview:self.playerTwoView];
//    [self.view sendSubviewToBack:self.playerTwoView];
//    
//    self.playerOneView = [[UIView alloc] initWithFrame:self.view.frame];
//    self.avPlayer = [[AVPlayer alloc] init];
//    //[self.avPlayer addObserver:self forKeyPath:@"currentItem" options:NSKeyValueObservingOptionNew context:CurrentItemObservationContext];
//    //[self.avPlayer addObserver:self forKeyPath:@"status" options:0 context:nil];
//    self.avPlayerLayer = [AVPlayerLayer playerLayerWithPlayer: self.avPlayer];
//    self.avPlayerLayer.frame = self.view.layer.bounds;
//    self.avPlayerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
//    [self.playerOneView.layer addSublayer:self.avPlayerLayer];
//    [self.view addSubview:self.playerOneView];
//    [self.view bringSubviewToFront:self.playerOneView];
//    
//    [self.avPlayerLayer removeAllAnimations];
//    [self.avPlayerLayerTwo removeAllAnimations];
//    
//    self.avPlayerLayer.hidden = YES;
//    self.avPlayerLayerTwo.hidden = YES;
//    
//    _playerOneReady = YES;
//    _playerTwoReady = YES;
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appClosed) name:UIApplicationDidEnterBackgroundNotification object:nil];
//    
//    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
//    [self.view addGestureRecognizer:pan];
//    
//}
//
//-(void)handlePanGesture:(UIPanGestureRecognizer *)sender {
//    
//    [self.avPlayer pause];
//    [self.avPlayerTwo pause];
//    
//    CGPoint translation = [sender translationInView:self.view];
//    CGFloat verticalMovement = translation.y / self.view.bounds.size.height*1.72;
//    float downwardMovement = fmaxf(verticalMovement, 0.0);
//    float downwardMovementPercent = fmin(downwardMovement, 1.0);
//    CGFloat progress = downwardMovementPercent;
//    
//    self.view.clipsToBounds = YES;
//    
//    self.view.alpha = 1-progress*1.36;
//    
//    //self.view.layer.cornerRadius = progress*34;
//    
//    if (sender.state == UIGestureRecognizerStateBegan) {
//        _controllerIsDismissing = TRUE;
//        self.interactor.hasStarted = TRUE;
//        [self dismissViewControllerAnimated:YES completion:nil];
//    }
//    if (sender.state == UIGestureRecognizerStateChanged) {
//        self.interactor.shouldFinish = progress > 0.3;
//        [self.interactor updateInteractiveTransition:progress];
//    }
//    if (sender.state == UIGestureRecognizerStateCancelled) {
//        [UIView animateWithDuration:0.1 animations:^{
//            self.view.alpha = 1.0;
//        } completion:^(BOOL finished) {
//        }];
//        [self.interactor cancelInteractiveTransition];
//    }
//    if (sender.state == UIGestureRecognizerStateEnded) {
//        
//        self.interactor.hasStarted = FALSE;
//        if (self.interactor.shouldFinish) {
//            [self.skipTimer invalidate];
//            [self.dasTimer invalidate];
//            [self.handleTapTimer invalidate];
//            [self.avPlayer pause];
//            [self.avPlayerTwo pause];
//            self.avPlayer = nil;
//            self.avPlayer = nil;
//            self.avPlayerTwo = nil;
//            //self.detector = nil;
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"change_home_pic" object:self];
//            _controllerIsDismissing = FALSE;
//            [self.interactor finishInteractiveTransition];
//        } else {
//            [UIView animateWithDuration:0.04 animations:^{
//                self.view.alpha = 1.0;
//                self.view.layer.cornerRadius = 0;
//            } completion:^(BOOL finished) {
//                [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
//            }];
//            [self.interactor cancelInteractiveTransition];
//        }
//    }
//}
//
//
//-(void)appClosed {
//    [ProgressHUD dismiss];
//    [UIApplication sharedApplication].statusBarHidden = YES;
//}
//
//
//-(void)setupTapTimer {
//    
//    PFObject *currentContent = [self.contentArray objectAtIndex:currentIndex];
//    
//    if ([[currentContent objectForKey:@"postType"] isEqualToString:@"video"]) {
//        
//        if (videoCount == 0 && _firstObjectVideo) {
//            canSkip = 0;
//            tempIndex = 0;
//        } else {
//            tempIndex = 0;
//            self.handleTapTimer = [NSTimer timerWithTimeInterval:[self playerItemDuration] target:self selector:@selector(handleSingleTap) userInfo:nil repeats:YES];
//            [[NSRunLoop currentRunLoop] addTimer:self.handleTapTimer forMode:NSDefaultRunLoopMode];
//        }
//        
//    } else {
//        self.handleTapTimer = [NSTimer timerWithTimeInterval:6.0 target:self selector:@selector(handleSingleTap) userInfo:nil repeats:YES];
//        [[NSRunLoop currentRunLoop] addTimer:self.handleTapTimer forMode:NSDefaultRunLoopMode];
//    }
//}
//
//-(void)showReplayView {
//    
//    _replayViewShowing = true;
//    [self.avPlayer pause];
//    [self.avPlayerTwo pause];
//    self.countDownLabel.text = @"";
//    
//    [self.handleTapTimer invalidate];
//    self.handleTapTimer = nil;
//    
//    self.subtitleLabel.hidden = YES;
//    
//    //    PFObject *lastObject = [self.contentArray lastObject];
//    //    [[NSUserDefaults standardUserDefaults] setObject:lastObject.objectId forKey:@"lastSeenContentId"];
//    //    [[NSUserDefaults standardUserDefaults] synchronize];
//    
//    self.replayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//    [self.view addSubview:self.replayView];
//    self.replayView.backgroundColor = [UIColor colorWithRed:0.33 green:0.51 blue:0.68 alpha:1.0];
//    self.replayButton = [[UIButton alloc] init];
//    self.replayButton.frame = CGRectMake(0, 0, 300, 100);
//    self.replayButton.center = self.view.center;
//    [self.replayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    
//    
//    if([UIScreen mainScreen].bounds.size.height < 568.0) {
//        self.replayButton.titleLabel.font = [UIFont fontWithName:@"AvenirNext-Bold" size:17];
//    }
//    else if([UIScreen mainScreen].bounds.size.height == 568.0) {
//        self.replayButton.titleLabel.font = [UIFont fontWithName:@"AvenirNext-Bold" size:17];
//    } else if ([UIScreen mainScreen].bounds.size.height == 667.0) {
//        self.replayButton.titleLabel.font = [UIFont fontWithName:@"AvenirNext-Bold" size:18.25];
//    } else  if ([UIScreen mainScreen].bounds.size.height == 736.0) {
//        self.replayButton.titleLabel.font = [UIFont fontWithName:@"AvenirNext-Bold" size:20.0];
//    }
//    
//    self.replayButton.titleLabel.numberOfLines = 2;
//    [self.replayButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
//    [self.replayButton setTitle:@"no new posts 🔄\ntap to replay" forState:UIControlStateNormal];
//    [self.replayButton addTarget:self action:@selector(replayShow) forControlEvents:UIControlEventTouchUpInside];
//    self.replayView.alpha = 0;
//    [self.replayView addSubview:self.replayButton];
//    
//    UITapGestureRecognizer *replayTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(replayShow)];
//    replayTap.numberOfTapsRequired = 1;
//    [self.replayView addGestureRecognizer:replayTap];
//    
//    [UIView animateWithDuration:0.16 delay:0.09 options:0 animations:^{
//        self.replayView.alpha = 1.0;
//    } completion:^(BOOL finished) {
//        
//    }];
//}
//
//-(void)replayShow {
//    
//    self.replayView.alpha = 0.0;
//    [self.view sendSubviewToBack:self.replayView];
//    
//    self.subtitleLabel.text = @"";
//    
//    currentIndex = 0;
//    currentSkipCount = 0;
//    self.countDownLabel.text = @"";
//    
//    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self.replayView removeFromSuperview];
//    });
//    
//    [self.replayView removeFromSuperview];
//    [self.view bringSubviewToFront:self.imageView];
//    [self replayQuery];
//    
//}
//
//-(void)methodToShowViewOnTop {
//    
//    [self goHome:self];
//}
//
//-(void)didReceiveMemoryWarning {
//    
//    SDImageCache *imageCache = [SDImageCache sharedImageCache];
//    [imageCache clearMemory];
//    [imageCache clearDisk];
//    [imageCache cleanDisk];
//    
//    [[[SDWebImageManager sharedManager] imageCache] clearMemory];
//    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
//    
//    [super didReceiveMemoryWarning];
//    
//    [self downloadImages];
//    
//}
//
//-(void)viewWillAppear:(BOOL)animated {
//    
//    if (_controllerIsDismissing) {
//        
//    } else {
//        
//        currentIndex = 0;
//        videoCount = 0;
//        imageCount = 0;
//        tempIndex = 0;
//        skipCount = 0;
//        
//        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
//        
//    }
//}
//
//-(void)viewDidAppear:(BOOL)animated {
//    
//    if (_controllerIsDismissing) {
//        
//    } else {
//        self.indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
//        self.indicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
//        self.indicator.center = self.view.center;
//        [self.indicator setHidden:NO];
//        [self.indicator startAnimating];
//        [self.view addSubview:self.indicator];
//    }
//}
//
//-(void)addTapTapRecoginzer {
//    
//    self.tapTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap)];
//    self.tapTap.delegate = (id)self;
//    self.tapTap.numberOfTapsRequired = 1;
//    self.tapTap.numberOfTouchesRequired = 1;
//    self.tapTap.delaysTouchesBegan = YES;
//    self.tapTap.delaysTouchesEnded = YES; //Important to add
//    [self.view addGestureRecognizer:self.tapTap];
//    
//}
//
//-(void)viewWillDisappear:(BOOL)animated {
//    
//    if (_controllerIsDismissing) {
//        [UIApplication sharedApplication].statusBarHidden = NO;
//    } else {
//        
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"change_home_pic" object:self];
//        [self.skipTimer invalidate];
//        [self.dasTimer invalidate];
//        [self.handleTapTimer invalidate];
//        [self.avPlayer pause];
//        [self.avPlayerTwo pause];
//        self.avPlayer = nil;
//        [[NSUserDefaults standardUserDefaults] synchronize];
//        
//        self.avPlayer = nil;
//        self.avPlayerTwo = nil;
//        //self.detector = nil;
//        
//    }
//}
//
//-(void)handleSingleTap {
//    
//    skipCount = skipCount + 1;
//    
//    if (canSkip == 1) {
//        
//    } else {
//        
//        if (_replayViewShowing) {
//            
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
//                
//                int i = [[[NSUserDefaults standardUserDefaults] objectForKey:@"storyViewCountReplayed"] intValue];
//                [[NSUserDefaults standardUserDefaults] setInteger:i+1 forKey:@"storyViewCountReplayed"];
//                
//            });
//            
//        } else {
//            
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
//                
//                int i = [[[NSUserDefaults standardUserDefaults] objectForKey:@"storyViewCount"] intValue];
//                [[NSUserDefaults standardUserDefaults] setInteger:i+1 forKey:@"storyViewCount"];
//                
//                PFObject *currentContent = [self.contentArray objectAtIndex:currentIndex];
//                [[NSUserDefaults standardUserDefaults] setObject:currentContent.objectId forKey:@"lastSeenContentId"];
//                
//            });
//        }
//        
//        [self.handleTapTimer invalidate];
//        
//        [self.avPlayer pause];
//        [self.avPlayerTwo pause];
//        
//        if (currentIndex+1 >= self.contentArray.count) {
//            
//            [self goHomeNotAnimated];
//            
//        } else {
//            
//            currentIndex = currentIndex + 1;
//            
//            double percentage;
//            percentage = 100.0*currentIndex/self.contentArray.count;
//            //self.progressView.progress = percentage/100;
//            
//            PFObject *currentContent = [self.contentArray objectAtIndex:currentIndex];
//            
//            if ([[currentContent objectForKey:@"postType"] isEqualToString:@"video"]) {
//            
//                
//            } else {
//                
//            }
//            
//            [self setupTapTimer];
//            [self displayContent];
//        }
//    }
//}
//
//-(void)displayContent {
//    
//    canSkip = 1;
//    PFObject *currentContent = [self.contentArray objectAtIndex:currentIndex];
//    
//    if ([[currentContent objectForKey:@"postType"] rangeOfString:@"video"].location != NSNotFound) {
//        
//        [self showVideoImageTemporarily];
//        
//    } else {
//        
//        [self showPicture];
//    }
//}
//
//
//-(void)showPicture {
//    
//    PFObject *currentContent = [self.contentArray objectAtIndex:currentIndex];
//    
//    NSString *urlString = [currentContent objectForKey:@"imageUrl"];
//    NSURL *url = [NSURL URLWithString:urlString];
//    
//    [self.manager downloadImageWithURL:url options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//        
//    }
//                             completed:^(UIImage *images, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
//                                 
//                                 self.imageView.image = images;
//                                 self.imageView.hidden = NO;
//                                 //[CATransaction setDisableActions:YES];
//                                 self.avPlayerLayer.hidden = YES;
//                                 self.avPlayerLayerTwo.hidden = YES;
//                                 [self.view bringSubviewToFront:self.imageView];
//                                 
//                                 if (finished) {
//                                     
//                                     [self addCaption];
//                                     [self performSelector:@selector(makeSkipable) withObject:nil afterDelay:0.125];
//                                     //[self makeSkipable];
//                                 }
//                                 
//                             }];
//}
//
//-(void)addCaption {
//    
//    PFObject *currentContent = [self.contentArray objectAtIndex:currentIndex];
//    CGFloat yOrigin = [[currentContent objectForKey:@"captionLocation"] floatValue];
//    float height = [[UIScreen mainScreen] bounds].size.height;
//    
//    CGRect frame = self.subtitleLabel.frame;
//    frame.origin.x = 0;
//    frame.origin.y = yOrigin*height;
//    self.subtitleLabel.frame = frame;
//    
//    self.subtitleLabel.text = [currentContent objectForKey:@"contentCaption"];
//    
//    if ([[currentContent objectForKey:@"contentCaption"] length] > 0) {
//        
//        self.subtitleLabel.hidden = NO;
//        [self.view bringSubviewToFront:self.subtitleLabel];
//        
//    } else {
//        self.subtitleLabel.hidden = YES;
//    }
//}
//
//-(void)playDasVideo {
//    
//    if (videoCount % 2 == 0) {
//        // even
//        [CATransaction setDisableActions:YES];
//        self.avPlayerLayerTwo.hidden = YES;
//        [self.view bringSubviewToFront:self.playerOneView];
//        self.avPlayerLayer.hidden = NO;
//        [self.view bringSubviewToFront:self.subtitleLabel];
//        [self.avPlayer play];
//        [self.view bringSubviewToFront:self.flagButton];
//        
//    } else {
//        //Odd
//        [CATransaction setDisableActions:YES];
//        self.avPlayerLayer.hidden = YES;
//        [self.view bringSubviewToFront:self.playerTwoView];
//        self.avPlayerLayerTwo.hidden = NO;
//        [self.view bringSubviewToFront:self.subtitleLabel];
//        [self.avPlayerTwo play];
//        [self.view bringSubviewToFront:self.flagButton];
//        
//    }
//    videoCount = videoCount + 1;
//}
//
//-(void)makeSkipable {
//    
//    canSkip = 0;
//}
//
//-(void)addVideoCaption {
//    
//    PFObject *currentContent = [self.contentArray objectAtIndex:currentIndex];
//    
//    CGFloat yOrigin = [[currentContent objectForKey:@"captionLocation"] floatValue];
//    float height = [[UIScreen mainScreen] bounds].size.height;
//    CGRect frame = self.subtitleLabel.frame;
//    frame.origin.x = 0;
//    frame.origin.y = yOrigin*height;
//    self.subtitleLabel.frame = frame;
//    self.subtitleLabel.text = [currentContent objectForKey:@"contentCaption"];
//    
//    if ([[currentContent objectForKey:@"contentCaption"] length] > 0) {
//        
//        self.subtitleLabel.hidden = NO;
//        [self.view bringSubviewToFront:self.subtitleLabel];
//        
//    } else {
//        self.subtitleLabel.hidden = YES;
//    }
//}
//
//-(void)showVideoImageTemporarily {
//    
//    PFObject *currentContent = [self.contentArray objectAtIndex:currentIndex];
//    NSString *urlString = [currentContent objectForKey:@"imageUrl"];
//    NSURL *url = [NSURL URLWithString:urlString];
//    
//    [self.manager downloadImageWithURL:url options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//        
//    }
//                             completed:^(UIImage *images, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
//                                 
//                                 self.imageView.image = images;
//                                 self.subtitleLabel.hidden = YES;
//                                 self.imageView.hidden = NO;
//                                 [CATransaction setDisableActions:YES];
//                                 self.avPlayerLayer.hidden = YES;
//                                 self.avPlayerLayerTwo.hidden = YES;
//                                 [self.view bringSubviewToFront:self.imageView];
//                                 
//                                 if (finished) {
//                                     [self addCaption];
//                                     [self playDasVideo];
//                                     [self preloadVideoPlayer];
//                                     //[self makeSkipable];
//                                     [self performSelector:@selector(makeSkipable) withObject:nil afterDelay:0.135];
//                                 }
//                             }];
//}
//
//-(void)showIfFirstObjectIsVideo {
//    
//    PFObject *currentContent = [self.contentArray objectAtIndex:currentIndex];
//    NSString *urlString = [currentContent objectForKey:@"videoUrl"];
//    NSURL *url = [NSURL URLWithString:urlString];
//    
//    self.avAsset = [AVAsset assetWithURL:url];
//    self.avPlayerItem = [AVPlayerItem playerItemWithAsset:self.avAsset];
//    [self.avPlayer replaceCurrentItemWithPlayerItem:self.avPlayerItem];
//    
//    [self.view bringSubviewToFront:self.playerOneView];
//    [self.view sendSubviewToBack:self.playerTwoView];
//    [self.avPlayer play];
//    
//    self.avPlayerLayer.hidden = NO;
//    
//    [self.view bringSubviewToFront:self.countDownLabel];
//    [self.view bringSubviewToFront:self.subtitleLabel];
//    
//    canSkip = 0;
//    
//    [self performSelector:@selector(doThis) withObject:nil afterDelay:0.25];
//}
//
//-(void)doThis {
//    
//    double percentageTwo;
//    percentageTwo = 100.0*7;
//    
//    AVPlayerItem *playerItem = [self.avPlayer currentItem];
//    
//    if (playerItem == nil) {
//        
//    }
////    double dur = CMTimeGetSeconds([[playerItem asset] duration]);
////    double time = dur;
////    self.progressViewTwo.animationDuration = time;
////    self.progressViewTwo.progress = 0;
////    self.progressViewTwo.progress = percentageTwo/100;
////    
////    self.handleTapTimer = [NSTimer timerWithTimeInterval:time target:self selector:@selector(handleSingleTap) userInfo:nil repeats:YES];
////    [[NSRunLoop currentRunLoop] addTimer:self.handleTapTimer forMode:NSDefaultRunLoopMode];
//    
//}
//
//- (double)playerItemDuration {
//    
//    if (videoCount % 2 == 0) {
//        AVPlayerItem *playerItem = [self.avPlayer currentItem];
//        if (playerItem.status == AVPlayerItemStatusReadyToPlay) {
//            
//            double dur = CMTimeGetSeconds([[playerItem asset] duration]);
//            return dur;
//        }
//        
//    } else {
//        AVPlayerItem *playerItem = [self.avPlayerTwo currentItem];
//        if (playerItem.status == AVPlayerItemStatusReadyToPlay) {
//            
//            double dur = CMTimeGetSeconds([[playerItem asset] duration]);
//            return dur;
//        }
//    }
//    
//    return 6;
//}
//
//-(void)tryThis {
//    
//}
//
//-(void)preloadVideoPlayer {
//    
//    if (videoCount == self.videoArray.count) {
//        
//    } else {
//        
//        if (videoCount % 2 == 0) {
//            //Even
//            if (videoCount > self.videoArray.count) {
//                
//            } else {
//                NSString *nextUrlString = [self.videoArray objectAtIndex:videoCount];
//                NSURL *url = [NSURL URLWithString:nextUrlString];
//                
//                //                self.avAsset = [AVAsset assetWithURL:url];
//                //                [self.avAsset loadValuesAsynchronouslyForKeys:@[@"duration"] completionHandler:^{
//                //                    self.avPlayerItem = [AVPlayerItem playerItemWithAsset:self.avAsset];
//                //                    [self.avPlayer replaceCurrentItemWithPlayerItem:self.avPlayerItem];
//                //                }];
//                
//                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
//                    self.avAsset = [AVAsset assetWithURL:url];
//                    self.avPlayerItem = [AVPlayerItem playerItemWithAsset:self.avAsset];
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [self.avPlayer replaceCurrentItemWithPlayerItem:self.avPlayerItem];
//                    });
//                });
//            }
//            
//        } else {
//            //Odd
//            if (videoCount > self.videoArray.count) {
//                
//            } else {
//                NSString *nextUrlString = [self.videoArray objectAtIndex:videoCount];
//                NSURL *url = [NSURL URLWithString:nextUrlString];
//                
//                //                self.avAssetTwo = [AVAsset assetWithURL:url];
//                //                [self.avAssetTwo loadValuesAsynchronouslyForKeys:@[@"duration"] completionHandler:^{
//                //                    self.avPlayerItemTwo = [AVPlayerItem playerItemWithAsset:self.avAssetTwo];
//                //                    [self.avPlayerTwo replaceCurrentItemWithPlayerItem:self.avPlayerItemTwo];
//                //                }];
//                
//                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
//                    self.avAssetTwo = [AVAsset assetWithURL:url];
//                    self.avPlayerItemTwo = [AVPlayerItem playerItemWithAsset:self.avAssetTwo];
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [self.avPlayerTwo replaceCurrentItemWithPlayerItem:self.avPlayerItemTwo];
//                    });
//                });
//            }
//        }
//    }
//}
//
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
//    
//    if (videoCount % 2 == 0) {
//        
//        if (object == self.avPlayer && [keyPath isEqualToString:@"status"]) {
//            if (self.avPlayer.status == AVPlayerStatusReadyToPlay) {
//                //NSLog(@"Player One Ready");
//            } else if (self.avPlayer.status == AVPlayerStatusFailed) {
//            }
//        }
//    } else {
//        
//        if (self.avPlayerTwo.status == AVPlayerStatusReadyToPlay) {
//            //NSLog(@"Player Two Ready");
//        } else if (self.avPlayerTwo.status == AVPlayerStatusFailed) {
//        }
//    }
//}
//
//-(void)queryForMedia {
//    
//    NSString *userSchoolId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userSchoolId"];
//    PFQuery *query = [PFQuery queryWithClassName:@"UserContent"];
//    [query whereKey:@"postStatus" equalTo:@"approved"];
//    [query whereKey:@"userSchoolId" equalTo:userSchoolId];
//    [query orderByDescending:@"createdAt"];
//    [query setLimit:100];
//    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        
//        if (error) {
//            
//        } else {
//            
//            [self.indicator stopAnimating];
//            [self.indicator setHidden:YES];
//            
//            if (objects.count == 0) {
//                
//                currentIndex = 0;
//                [self showReplayView];
//                return;
//            }
//            
//            self.contentArray = [objects mutableCopy];
//            NSArray* reversedArray = [[self.contentArray reverseObjectEnumerator] allObjects];
//            self.contentArray = [reversedArray mutableCopy];
//            
//            skipIndex = 0;
//            
//            PFObject *lastObject = [self.contentArray lastObject];
//            
//            if ([lastObject.objectId isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"lastSeenContentId"]]) {
//                
//                currentIndex = 0;
//                [self showReplayView];
//                return;
//                
//            } else {
//                
//                self.updatedVideoArray = [[NSMutableArray alloc] init];
//                
//                for (PFObject *object in self.contentArray) {
//                    NSString *objectId = [object valueForKey:@"objectId"];
//                    
//                    skipIndex++;
//                    
//                    //Create new video array to remove older videos
//                    if ([[object objectForKey:@"postType"] isEqualToString:@"video"]) {
//                        NSString *urlString = [object objectForKey:@"videoUrl"];
//                        [self.updatedVideoArray addObject:urlString];
//                    }
//                    
//                    if ([objectId isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"lastSeenContentId"]]) {
//                        
//                        currentIndex = skipIndex;
//                        [self displayContent]; //??????
//                        [self downloadImages];
//                        [self getVideos];
//                        [self addTapTapRecoginzer];
//                        [self checkIfFirstObjectIsVideo];
//                        
//                        return;
//                    }
//                }
//            }
//            [self displayContent];
//            [self.updatedVideoArray removeAllObjects];
//            [self downloadImages];
//            [self getVideos];
//            [self checkIfFirstObjectIsVideo];
//            [self addTapTapRecoginzer];
//        }
//    }];
//}
//
//-(void)replayQuery {
//    
//    currentIndex = 0;
//    videoCount = 0;
//    [self displayContent];
//    [self downloadImages];
//    [self getVideos];
//    [self addTapTapRecoginzer];
//    [self checkIfFirstObjectIsVideo];
//    
//}
//
//-(void)checkIfFirstObjectIsVideo {
//    
//    PFObject *currentContent = [self.contentArray objectAtIndex:currentIndex];
//    
//    if ([[currentContent objectForKey:@"postType"] isEqualToString:@"video"]) {
//        
//        tempIndex = 1;
//        _firstObjectVideo = YES;
//        [self showIfFirstObjectIsVideo];
//        
//    } else {
//        
//        [self.handleTapTimer invalidate];
//        [self setupTapTimer];
//        [self displayContent];
//    }
//}
//
//-(void)getVideos {
//    
//    self.videoArray = [[NSMutableArray alloc] init];
//    
//    for (PFObject *object in self.contentArray) {
//        
//        NSString *postType = [object valueForKey:@"postType"];
//        
//        if ([postType isEqualToString:@"video"]) {
//            NSString *urlString = [object objectForKey:@"videoUrl"];
//            [self.videoArray addObject:urlString];
//        }
//    }
//    
//    [self.videoArray removeObjectsInArray:self.updatedVideoArray];
//    [self preloadVideoPlayer];
//}
//
//-(void)downloadImages {
//    
//    for (PFObject *object in self.contentArray) {
//        
//        NSString *urlString = [object objectForKey:@"imageUrl"];
//        NSURL *url = [NSURL URLWithString:urlString];
//        
//        SDWebImageManager *managerTwo = [SDWebImageManager sharedManager];
//        
//        if ([managerTwo cachedImageExistsForURL:url]) {
//            imageCount = imageCount + 1;
//            
//        } else {
//            
//            [managerTwo downloadImageWithURL:url options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//            }
//                                   completed:^(UIImage *images, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
//                                       
//                                       imageCount = imageCount + 1;
//                                       
//                                   }];
//        }
//    }
//}
//
//-(void)downloadVideos {
//    
//    self.playerItemArray = [[NSMutableArray alloc] init];
//    
//    for (PFObject *object in self.contentArray) {
//        NSString *urlString = [object objectForKey:@"imageUrl"];
//        NSURL *url = [NSURL URLWithString:urlString];
//        
//        AVAsset *asset = [AVAsset assetWithURL:url];
//        
//        if (asset == nil) {
//            
//        } else {
//            
//            [asset loadValuesAsynchronouslyForKeys:@[@"duration"] completionHandler:^{
//                AVPlayerItem *item = [AVPlayerItem playerItemWithAsset:asset];
//                
//                [self.playerItemArray addObject:item];
//            }];
//        }
//    }
//}
//
//-(IBAction)goHome:(id)sender {
//    
//    [UIView animateWithDuration:0.1 animations:^{
//        self.subtitleLabel.alpha = 0.0;
//    } completion:^(BOOL finished) {
//    }];
//    
//    [self.handleTapTimer invalidate];
//    
//    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
//    
//    [self dismissViewControllerAnimated:YES completion:nil];
//    
//}
//
//-(IBAction)goHomeNotAnimated {
//    
//    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
//    [self dismissViewControllerAnimated:NO completion:nil];
//    
//}
//
//- (IBAction)flagButtonTapped:(id)sender {
//    PFObject *currentContent = [self.contentArray objectAtIndex:currentIndex];
//    [currentContent incrementKey:@"flagCount"];
//    [currentContent saveEventually];
//}
//
//@end
