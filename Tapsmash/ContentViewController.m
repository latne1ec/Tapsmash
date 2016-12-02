//
//  ContentViewController.m
//  Tapsmash
//
//  Created by Evan Latner on 11/17/15.
//  Copyright © 2015 tapsmash. All rights reserved.
//

#import "ContentViewController.h"
#import "SDWebImageManager.h"
#import "AppDelegate.h"
#import "WelcomeViewController.h"

@interface ContentViewController ()

@property (nonatomic, strong) AppDelegate *appDelegate;
@property BOOL replayViewShowing;
@property BOOL currentlyQuerying;
@property (nonatomic, strong) UIView *replayView;
@property (nonatomic, strong) UIView *playerOneView;
@property (nonatomic, strong) UIView *playerTwoView;
@property (nonatomic, strong) NSMutableArray *updatedVideoArray;
@property (nonatomic) BOOL controllerIsDismissing;
@property (nonatomic) BOOL shareShowing;
@property (nonatomic, strong) NSMutableArray *playerItemArray;
@property (nonatomic) BOOL playerAPlaying;
@property (nonatomic) BOOL playerBPlaying;

@end

@implementation ContentViewController

int currentIndex;
int currentSkipCount;
int videoCount;
int canSkip;


-(BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _shareShowing = NO;
    _playerAPlaying = false;
    _playerBPlaying = false;
    
    _appDelegate = [[UIApplication sharedApplication] delegate];
    
    _replayViewShowing = false;
    _currentlyQuerying = false;
    
    self.indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.indicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
    self.indicator.center = self.view.center;
    
    _controllerIsDismissing = FALSE;
    
    self.view.backgroundColor = [UIColor blackColor];
    self.playerView.hidden = YES;
    [self performSelector:@selector(queryForContent) withObject:nil afterDelay:0.45];
    
    
    self.avPlayer = [[AVPlayer alloc] init];
    self.avPlayerItem = [AVPlayerItem alloc];
    self.urlAsset = [AVURLAsset alloc];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:[self.avPlayer currentItem]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:[self.avPlayerTwo currentItem]];
    
    
    currentSkipCount = 0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillResignActive) name:UIApplicationWillResignActiveNotification object:nil]; 
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];

    [self.navigationController setNavigationBarHidden:YES];

    
    self.subtitleLabel.adjustsFontSizeToFitWidth = YES;
    self.subtitleLabel.minimumScaleFactor = 0;
    
    self.playerTwoView = [[UIView alloc] initWithFrame:self.view.frame];
    self.avPlayerTwo = [[AVPlayer alloc] init];
    //[self.avPlayerTwo addObserver:self forKeyPath:@"currentItem" options:NSKeyValueObservingOptionNew context:CurrentItemObservationContext];
    //[self.avPlayerTwo addObserver:self forKeyPath:@"status" options:0 context:nil];
    self.avPlayerLayerTwo = [AVPlayerLayer playerLayerWithPlayer: self.avPlayerTwo];
    self.avPlayerLayerTwo.frame = self.view.layer.bounds;
    self.avPlayerLayerTwo.videoGravity = AVLayerVideoGravityResizeAspect;
    [self.playerTwoView.layer addSublayer:self.avPlayerLayerTwo];
    [self.view addSubview:self.playerTwoView];
    [self.view sendSubviewToBack:self.playerTwoView];
    
    self.playerOneView = [[UIView alloc] initWithFrame:self.view.frame];
    self.avPlayer = [[AVPlayer alloc] init];
    //[self.avPlayer addObserver:self forKeyPath:@"currentItem" options:NSKeyValueObservingOptionNew context:CurrentItemObservationContext];
    //[self.avPlayer addObserver:self forKeyPath:@"status" options:0 context:nil];
    self.avPlayerLayer = [AVPlayerLayer playerLayerWithPlayer: self.avPlayer];
    self.avPlayerLayer.frame = self.view.layer.bounds;
    self.avPlayerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    [self.playerOneView.layer addSublayer:self.avPlayerLayer];
    [self.view addSubview:self.playerOneView];
    [self.view bringSubviewToFront:self.playerOneView];
    
    [self.avPlayerLayer removeAllAnimations];
    [self.avPlayerLayerTwo removeAllAnimations];
    
    self.avPlayerLayer.hidden = YES;
    self.avPlayerLayerTwo.hidden = YES;
    
//    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
//    [self.view addGestureRecognizer:pan];
    
    [self.view bringSubviewToFront:self.shareButton];
    self.shareButton.hidden = YES;
    
    UILongPressGestureRecognizer *sharePress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(doThis:)];
    sharePress.delegate = (id)self;
    sharePress.minimumPressDuration = 0.01;
    [self.shareButton addGestureRecognizer:sharePress];
    
    [self.view addSubview:self.indicator];
    [self.indicator setHidden:NO];
    [self.indicator startAnimating];
    
}

-(void)setupTimer {
    
    self.dasTimer = [NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(resumeTheVideo) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.dasTimer forMode:NSDefaultRunLoopMode];
}

-(void)resumeTheVideo {
        
    if (self.contentArray.count > 0) {
        
        if (_shareShowing) {
            
        } else {
            
            PFObject *currentContent = [self.contentArray objectAtIndex:currentIndex];
            if ([[currentContent objectForKey:@"postType"] rangeOfString:@"video"].location != NSNotFound) {
             
                if (_playerAPlaying) {
                    [self.avPlayer play];
                } else if (_playerBPlaying) {
                    [self.avPlayerTwo play];
                }
            }
        }
    }
}

-(void)handlePanGesture:(UIPanGestureRecognizer *)sender {

    [self.avPlayer pause];
    [self.avPlayerTwo pause];
    
    CGPoint velocity = [sender velocityInView:self.view];
    
    if(velocity.y > 0) {
        //NSLog(@"gesture went down");
    } else {
        //NSLog(@"gesture went up");
    }
    
    CGPoint translation = [sender translationInView:self.view];
    CGFloat verticalMovement = translation.y / self.view.bounds.size.height*1.72;
    float downwardMovement = fmaxf(verticalMovement, 0.0);
    float downwardMovementPercent = fmin(downwardMovement, 1.0);
    CGFloat progress = downwardMovementPercent;
    
    self.view.clipsToBounds = YES;
    
    self.view.alpha = 1-progress*0.50;
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        _controllerIsDismissing = TRUE;
        self.interactor.hasStarted = TRUE;
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    if (sender.state == UIGestureRecognizerStateChanged) {
        self.interactor.shouldFinish = progress > 0.33;
        [self.interactor updateInteractiveTransition:progress];
    }
    if (sender.state == UIGestureRecognizerStateCancelled) {
        [UIView animateWithDuration:0.1 animations:^{
            self.view.alpha = 1.0;
        } completion:^(BOOL finished) {
        }];
        [self.interactor cancelInteractiveTransition];
    }
    if (sender.state == UIGestureRecognizerStateEnded) {
        
        self.interactor.hasStarted = FALSE;
        if (self.interactor.shouldFinish) {
           
            [self.avPlayer pause];
            [self.avPlayerTwo pause];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"change_home_pic" object:self];
            _controllerIsDismissing = FALSE;
            [self.interactor finishInteractiveTransition];
        } else {
            [UIView animateWithDuration:0.04 animations:^{
                self.view.alpha = 1.0;
                self.view.layer.cornerRadius = 0;
            } completion:^(BOOL finished) {
                [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
            }];
            [self.interactor cancelInteractiveTransition];
        }
    }
}


-(void)appDidBecomeActive {
    
    if (self.contentArray.count > 0) {

        PFObject *currentContent = [self.contentArray objectAtIndex:currentIndex];
        if ([[currentContent objectForKey:@"postType"] rangeOfString:@"video"].location != NSNotFound) {
            if (_playerAPlaying) {
                [self.avPlayer play];
            } else if (_playerBPlaying) {
                [self.avPlayerTwo play];
            }
        }
    }
}

-(void)addTapTapRecoginzer {
    
    self.tapTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap)];
    self.tapTap.delegate = (id)self;
    self.tapTap.numberOfTapsRequired = 1;
    self.tapTap.numberOfTouchesRequired = 1;
    self.tapTap.delaysTouchesBegan = YES;      //Important to add
    [self.view addGestureRecognizer:self.tapTap];

}

-(void)appWillResignActive {
    
    [self.avPlayer pause];
    [self.indicator setHidden:YES];
    [self.dasTimer invalidate];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if (_replayViewShowing) {
        [self performSelector:@selector(fadehome) withObject:nil afterDelay:0.63];
    }
    if (_currentlyQuerying) {
        [self performSelector:@selector(fadehome) withObject:nil afterDelay:0.63];
    }
}

-(void)fadehome {
    
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    CATransition *transition = [CATransition animation];
    [transition setType:kCATransitionFade];
    [self.navigationController.view.layer addAnimation:transition forKey:@"someAnimation"];
    [UIApplication sharedApplication].statusBarHidden = NO;
    //[self.navigationController popToRootViewControllerAnimated:NO];
    [self dismissViewControllerAnimated:NO completion:nil];
    [CATransaction commit];
    
}

-(void)viewWillDisappear:(BOOL)animated {
    
//    AppDelegate *appD = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    [appD registerUserForOneSignalPushNotifications];
    
    [[NSNotificationCenter defaultCenter] removeObserver:UIApplicationWillResignActiveNotification];
    [[NSNotificationCenter defaultCenter] removeObserver:UIApplicationDidBecomeActiveNotification];
    
    [self.qPlayer pause];
    //[self.indicator setHidden:YES];
    [self.dasTimer invalidate];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if (self.webview.observationInfo == nil) {
    } else {
        [self.webview removeObserver:self forKeyPath:@"estimatedProgress"];
    }
}

-(void)viewWillAppear:(BOOL)animated {
    
    if (_controllerIsDismissing) {
       
        PFObject *currentContent = [self.contentArray objectAtIndex:currentIndex];
        if ([[currentContent objectForKey:@"postType"] rangeOfString:@"video"].location != NSNotFound) {
            
            if (_playerAPlaying) {
                [self.avPlayer play];
            } else if (_playerBPlaying) {
                [self.avPlayerTwo play];
            }
        }

    } else {
    
    self.navigationController.navigationBar.backItem.hidesBackButton = YES;
    [self.navigationItem setHidesBackButton:YES animated:YES];
        
        if (_shareShowing) {
            _shareShowing = NO;
        } else {
            currentIndex = 0;
            videoCount = 0;
        }
    }
    
    [self.indicator startAnimating];
    [self.indicator setHidden:false];
}

-(void)showReplayView {
    
    _replayViewShowing = true;
    [self.avPlayer pause];
    
    self.indicator.hidden = YES;
    
    PFObject *lastObject = [self.contentArray lastObject];
    [[NSUserDefaults standardUserDefaults] setObject:lastObject.objectId forKey:@"lastSeenContentId"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    self.replayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:self.replayView];
    self.replayView.backgroundColor = [UIColor colorWithRed:0.004 green:0.694 blue:0.953 alpha:1];
    self.replayView.alpha = 1.0;
    self.replayButton = [[UIButton alloc] init];
    self.replayButton.frame = CGRectMake(0, 0, 300, 100);
    self.replayButton.center = self.view.center;
    [self.replayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.replayButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateSelected];
    self.replayButton.titleLabel.font = [UIFont fontWithName:@"AvenirNext-Heavy" size:19.0];
    self.replayButton.titleLabel.numberOfLines = 2;
    [self.replayButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.replayButton setTitle:@"no new posts 🔄\ntap to replay" forState:UIControlStateNormal];
    [self.replayButton addTarget:self action:@selector(replayShow) forControlEvents:UIControlEventTouchUpInside];
    self.replayButton.alpha = 1.0;
    UIButton *buttonTwo = [[UIButton alloc] init];
    buttonTwo.frame = CGRectMake(self.replayButton.frame.origin.x, self.replayButton.frame.origin.y+200, 300, 100);
    //buttonTwo.center = self.view.center;
    [buttonTwo setTitleColor:[UIColor colorWithWhite:1 alpha:0.94] forState:UIControlStateNormal];
    [buttonTwo setTitleColor:[UIColor colorWithWhite:1 alpha:0.94] forState:UIControlStateSelected];
    buttonTwo.titleLabel.font = [UIFont fontWithName:@"AvenirNext-Bold" size:18];
    buttonTwo.titleLabel.numberOfLines = 2;
    [buttonTwo.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [buttonTwo setTitle:@"home" forState:UIControlStateNormal];
    [buttonTwo addTarget:self action:@selector(didCloseButtonTouch) forControlEvents:UIControlEventTouchUpInside];
    
    [self.replayView addSubview:self.replayButton];
    
    UITapGestureRecognizer *replayTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(replayShow)];
    replayTap.numberOfTapsRequired = 1;
    [self.replayView addGestureRecognizer:replayTap];
    
}

-(void)replayShow {
    
    self.view.backgroundColor = [UIColor blackColor];
    
    self.replayView.backgroundColor = [UIColor blackColor];
    [self.view sendSubviewToBack:self.replayView];
    
    self.subtitleLabel.text = @"";
    self.playerOneView.hidden = YES;
    self.playerTwoView.hidden = YES;
    currentIndex = 0;
    currentSkipCount = 0;
    self.contentCountLabel.text = @"";
    self.imageView.hidden = YES;
        
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.replayView removeFromSuperview];
    });
    
    [self.replayView removeFromSuperview];
    [self replayQuery];
    
}


-(void)handleSingleTap {
    
    currentSkipCount++;
    _playerAPlaying = false;
    _playerBPlaying = false;
    
    if (canSkip == 1) {
        
    } else {
    
        if (_replayViewShowing) {
            
        } else {
        
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
                int i = [[[NSUserDefaults standardUserDefaults] objectForKey:@"localUserScore"] intValue];
                [[NSUserDefaults standardUserDefaults] setInteger:i+1 forKey:@"localUserScore"];
                
                PFObject *currentContent = [self.contentArray objectAtIndex:currentIndex];
                [[NSUserDefaults standardUserDefaults] setObject:currentContent.objectId forKey:@"lastSeenContentId"];
                
            });
        }
    
        [self.avPlayer pause];
        [self.avPlayerTwo pause];

    
        if (currentIndex+1 >= self.contentArray.count) {
            
            [self.indicator setHidden:NO];
            [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"AnimateScore"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self dismissViewControllerAnimated:NO completion:nil];
            [self.dasTimer invalidate];
            
        } else {
            
            currentIndex = currentIndex + 1;
            
            PFObject *currentContent = [self.contentArray objectAtIndex:currentIndex];
            
            if ([[currentContent objectForKey:@"postType"] rangeOfString:@"video"].location != NSNotFound) {
            
            }
            
            [self displayContent];
        }
    }
}

-(void)displayContent {
    
    canSkip = 1;
    
    PFObject *currentContent = [self.contentArray objectAtIndex:currentIndex];
    
    if ([[currentContent objectForKey:@"postType"] rangeOfString:@"video"].location != NSNotFound) {
        
        [self performSelector:@selector(playDasVideo) withObject:nil afterDelay:0.075];
        [self performSelector:@selector(preloadVideoPlayer) withObject:nil afterDelay:0.075];
        //[self playDasVideo];
        //[self preloadVideoPlayer];
        
    } else {
        [self showPicture];
    }
    
    self.contentCountLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.contentArray.count - currentIndex];
    
//    [self.view bringSubviewToFront:self.indicator];
//    [self.indicator startAnimating];
//    self.indicator.hidden = false;
    
}

-(void)showPicture {
    
    [self.avPlayer pause];
    [self.avPlayerTwo pause];
    
    PFObject *currentContent = [self.contentArray objectAtIndex:currentIndex];
    
    SDWebImageManager *managerOne = [SDWebImageManager sharedManager];
    
    NSString *urlString = [currentContent objectForKey:@"postLink"];
    NSURL *url = [NSURL URLWithString:urlString];
    
    [managerOne downloadImageWithURL:url options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    }
                           completed:^(UIImage *images, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                               
                               [CATransaction setDisableActions:YES];
                               self.avPlayerLayer.hidden = YES;
                               self.avPlayerLayerTwo.hidden = YES;
                               self.imageView.image = images;
                               self.imageView.hidden = NO;
                               [self.view bringSubviewToFront:self.imageView];
                               [CATransaction setDisableActions:YES];
                               
                               if (finished) {
                                   self.subtitleLabel.text = [currentContent objectForKey:@"postTitle"];
                                   self.contentCountLabel.hidden = NO;
                                   self.subtitleLabel.hidden = NO;
                                   self.shareButton.hidden = NO;
                                   [self.view bringSubviewToFront:self.subtitleLabel];
                                   [self performSelector:@selector(makeSkipable) withObject:nil afterDelay:0.135];
                               }
                               
                               [self.view bringSubviewToFront:self.imageView];
                               [self.view bringSubviewToFront:self.bottomFade];
                               [self.view bringSubviewToFront:self.topFade];
                               [self.view bringSubviewToFront:self.contentCountLabel];
                               [self.view bringSubviewToFront:self.subtitleLabel];
                               [self.view bringSubviewToFront:self.likeButton];
                               [self.view bringSubviewToFront:self.shareButton];
                           }];
}


//// ********************* VIDEO

-(void)playerItemDidReachEnd:(NSNotification *)notification  {
        
//    if (currentIndex+1 >= self.contentArray.count) {
//        [self.dasTimer invalidate];
//        self.dasTimer = nil;
//    }
    
    AVPlayerItem *p = [notification object];
    [p seekToTime:kCMTimeZero];
    
    if (videoCount % 2 == 0) {
        [self.avPlayerTwo play];
    } else {
        [self.avPlayer play];
    }
        
    //[self handleSingleTap];
}

-(void)playDasVideo {
    
    if (videoCount % 2 == 0) {
        // even
        [CATransaction setDisableActions:YES];
        self.avPlayerLayerTwo.hidden = YES;
        self.playerOneView.hidden = NO;
        [self.view bringSubviewToFront:self.playerOneView];
        self.avPlayerLayer.hidden = NO;
        [self.view bringSubviewToFront:self.subtitleLabel];
        [self.avPlayer play];
        _playerAPlaying = true;
        
    } else {
        //Odd
        [CATransaction setDisableActions:YES];
        self.avPlayerLayer.hidden = YES;
        self.playerTwoView.hidden = NO;
        [self.view bringSubviewToFront:self.playerTwoView];
        self.avPlayerLayerTwo.hidden = NO;
        [self.view bringSubviewToFront:self.subtitleLabel];
        [self.avPlayerTwo play];
        _playerBPlaying = true;
        
    }
    
    [self.view bringSubviewToFront:self.bottomFade];
    [self.view bringSubviewToFront:self.topFade];
    [self.view bringSubviewToFront:self.contentCountLabel];
    [self.view bringSubviewToFront:self.subtitleLabel];
    [self.view bringSubviewToFront:self.likeButton];
    self.shareButton.hidden = NO;
    [self.view bringSubviewToFront:self.shareButton];
    [self addcaption];
    self.imageView.hidden = true;
    
    [self performSelector:@selector(makeSkipable) withObject:nil afterDelay:0.135];
    
    videoCount = videoCount + 1;
    
}

-(void)makeSkipable {
    
    canSkip = 0;
}

-(void)addcaption {
    
    PFObject *currentContent = [self.contentArray objectAtIndex:currentIndex];

    self.subtitleLabel.text = [currentContent objectForKey:@"postTitle"];
    self.subtitleLabel.hidden = NO;
    [self.view bringSubviewToFront:self.subtitleLabel];
    
}

- (void)didCloseButtonTouch {
    
    [self.navigationController popToRootViewControllerAnimated:NO];
}

-(void)queryForContent {
    
    _currentlyQuerying = true;
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:( NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond ) fromDate:[[NSDate alloc] init]];
    
    [components setHour:-48];
    [components setMinute:0];
    [components setSecond:0];
    NSDate *yesterday = [cal dateByAddingComponents:components toDate: [NSDate date] options:0];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Posts"];
    [query whereKey:@"postChannel" notEqualTo:@"nil"];
    [query whereKey:@"postType" equalTo:@"video"];
    //[query whereKey:@"postSource" equalTo:@"twitter"];
    [query whereKey:@"createdAt" greaterThanOrEqualTo:yesterday];
    [query orderByDescending:@"createdAt"];
    [query setLimit:100];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (error) {
            _currentlyQuerying = false;
        } else {
            
            if (objects.count == 0) {
            }
            
            self.contentArray = [objects mutableCopy];
            
            NSArray* reversedArray = [[self.contentArray reverseObjectEnumerator] allObjects];
            
            self.contentArray = [reversedArray mutableCopy];
            
            int i = 0;
            
            PFObject *lastObject = [self.contentArray lastObject];
            
            _currentlyQuerying = false;
            
            if ([lastObject.objectId isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"lastSeenContentId"]]) {
                [self showReplayView];
                return;
            } else {
                
                self.updatedVideoArray = [[NSMutableArray alloc] init];
            
                for (PFObject *object in self.contentArray) {
                    NSString *objectId = [object valueForKey:@"objectId"];
                    
                    i++;
                    
                    //Create new video array to remove older videos
                    if ([[object objectForKey:@"postType"] isEqualToString:@"video"]) {
                        NSString *urlString = [object objectForKey:@"postLink"];
                        [self.updatedVideoArray addObject:urlString];
                    }
                    
                    if ([objectId isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"lastSeenContentId"]]) {
                        
                        currentIndex = i;
                        [self displayContent];
                        //[self downloadImages];
                        [self getVideos];
                        [self setupTimer];
                        self.contentCountLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.contentArray.count-currentIndex];
                        [self addTapTapRecoginzer];
                        [self checkIfFirstObjectIsVideo];
                        
                        return;
                    } 
                }
                
                NSLog(@"here 2");
            [self.updatedVideoArray removeAllObjects];
            [self displayContent];
            //[self downloadImages];
                NSLog(@"here 1");
            [self getVideos];
            [self checkIfFirstObjectIsVideo];
            [self setupTimer];
                NSLog(@"here");
            [self addTapTapRecoginzer];
            self.contentCountLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.contentArray.count];
                
            }
        }
    }];
}

-(void)replayQuery {

    currentIndex = 0;
    videoCount = 0;
    [self displayContent];
    [self downloadImages];
    [self getVideos];
    [self addTapTapRecoginzer];
    [self checkIfFirstObjectIsVideo];
    [self setupTimer];
     self.contentCountLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.contentArray.count];
}

-(void)checkIfFirstObjectIsVideo {
    
    PFObject *currentContent = [self.contentArray objectAtIndex:currentIndex];
    
    if ([[currentContent objectForKey:@"postType"] isEqualToString:@"video"]) {
    
        [self showIfFirstObjectIsVideo];
        
    } else {
        
        [self displayContent];
    }
}

-(void)showIfFirstObjectIsVideo {
    
    PFObject *currentContent = [self.contentArray objectAtIndex:currentIndex];
    NSString *urlString = [currentContent objectForKey:@"postLink"];
    NSURL *url = [NSURL URLWithString:urlString];
    
    self.avAsset = [AVAsset assetWithURL:url];
    self.avPlayerItem = [AVPlayerItem playerItemWithAsset:self.avAsset];
    [self.avPlayer replaceCurrentItemWithPlayerItem:self.avPlayerItem];
    
    [self.view bringSubviewToFront:self.playerOneView];
    [self.view sendSubviewToBack:self.playerTwoView];
    [self.avPlayer play];
    
    self.avPlayerLayer.hidden = NO;

    [self.view bringSubviewToFront:self.bottomFade];
    [self.view bringSubviewToFront:self.topFade];
    [self.view bringSubviewToFront:self.contentCountLabel];
    [self.view bringSubviewToFront:self.subtitleLabel];
    [self.view bringSubviewToFront:self.likeButton];
    self.shareButton.hidden = NO;
    [self.view bringSubviewToFront:self.shareButton];
    [self addcaption];

    canSkip = 0;
    
}

-(void)downloadImages {
    
    for (PFObject *object in self.contentArray) {
        NSString *postType = [object valueForKey:@"postType"];
        NSString *urlString = [object objectForKey:@"postLink"];
        NSURL *url = [NSURL URLWithString:urlString];
        
        if ([postType rangeOfString:@"image"].location != NSNotFound) {
            SDWebImageManager *managerTwo = [SDWebImageManager sharedManager];
            
            if ([managerTwo cachedImageExistsForURL:url]) {
                //NSLog(@"already got em champ");
            } else {
                
                [managerTwo downloadImageWithURL:url options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                }
                                       completed:^(UIImage *images, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                           NSLog(@"Image: %@", images);
                                           
                                       }];
            }
        }
    }
}


-(void)getVideos {
    
    self.videoArray = [[NSMutableArray alloc] init];
    
    for (PFObject *object in self.contentArray) {
        
        NSString *postType = [object valueForKey:@"postType"];
        
        if ([postType isEqualToString:@"video"]) {
            NSString *urlString = [object objectForKey:@"postLink"];
            [self.videoArray addObject:urlString];
        }
    }
    
    [self.videoArray removeObjectsInArray:self.updatedVideoArray];
    [self preloadVideoPlayer];
    //[self getVideoThumbnails];
}

-(void)getVideoThumbnails {
    
    for (NSString *urlString in self.videoArray) {
        
        //NSString *urlString = [object objectForKey:@"postLink"];
        NSURL *url = [NSURL URLWithString:urlString];
        
        AVURLAsset *asset=[[AVURLAsset alloc] initWithURL:url options:nil];
        AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
        generator.appliesPreferredTrackTransform=TRUE;
        CMTime thumbTime = CMTimeMakeWithSeconds(0,1);
        
        AVAssetImageGeneratorCompletionHandler handler = ^(CMTime requestedTime, CGImageRef im, CMTime actualTime, AVAssetImageGeneratorResult result, NSError *error){
            
        };

        CGSize maxSize = CGSizeMake(20, 20);
        generator.maximumSize = maxSize;
        [generator generateCGImagesAsynchronouslyForTimes:[NSArray arrayWithObject:[NSValue valueWithCMTime:thumbTime]] completionHandler:handler];

    }
}

-(void)preloadVideoPlayer {
    
    if (videoCount == self.videoArray.count) {
        
    } else {
        
        if (videoCount % 2 == 0) {
            //Even
            if (videoCount > self.videoArray.count) {
                
            } else {
                NSString *nextUrlString = [self.videoArray objectAtIndex:videoCount];
                NSURL *url = [NSURL URLWithString:nextUrlString];
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                    self.avAsset = [AVAsset assetWithURL:url];
                    self.avPlayerItem = [AVPlayerItem playerItemWithAsset:self.avAsset];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.avPlayer replaceCurrentItemWithPlayerItem:self.avPlayerItem];
                    });
                });
            }
            
        } else {
            //Odd
            if (videoCount > self.videoArray.count) {
                
            } else {
                NSString *nextUrlString = [self.videoArray objectAtIndex:videoCount];
                NSURL *url = [NSURL URLWithString:nextUrlString];
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                    self.avAssetTwo = [AVAsset assetWithURL:url];
                    self.avPlayerItemTwo = [AVPlayerItem playerItemWithAsset:self.avAssetTwo];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.avPlayerTwo replaceCurrentItemWithPlayerItem:self.avPlayerItemTwo];
                    });
                });
            }
        }
    }
}

-(void)doThis: (UILongPressGestureRecognizer *)recognizer {
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        
        [UIView animateWithDuration:0.125 animations:^{
            
            self.shareButton.transform = CGAffineTransformMakeScale(1.224, 1.224);
            
        } completion:^(BOOL finished) {
            
        }];
    }
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {

        [ProgressHUD show:nil Interaction:NO];
        
        [UIView animateWithDuration:0.125 animations:^{
            self.shareButton.transform = CGAffineTransformMakeScale(1.0, 1.0);
            
        } completion:^(BOOL finished) {
            
            [self shareButtonPressed];
        }];
    }
}

-(void)shareButtonPressed {
    
    self.objectsToShare = [[NSArray alloc] init];
    [self.avPlayer pause];
    [self.avPlayerTwo pause];
    _shareShowing = YES;
    
    PFObject *currentContent = [self.contentArray objectAtIndex:currentIndex];
    NSString* newString = @"Shared via Tapsmash";
    NSString *urlString = [currentContent objectForKey:@"postLink"];
    NSURL *videoLink = [NSURL URLWithString:urlString];
    
    NSData *videoData = [NSData dataWithContentsOfURL:videoLink];
    [videoData writeToFile:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/image.mov"] atomically:YES];
    NSString* path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/image.mov"];
    NSURL *videoURL = [NSURL fileURLWithPath:path];
    
    if ([[currentContent objectForKey:@"postType"] isEqualToString:@"image"]) {
        self.objectsToShare = @[newString, self.imageView.image];
    } else {
        self.objectsToShare = @[newString, videoURL];
    }
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:self.objectsToShare applicationActivities:nil];
    
    
    NSArray *excludeActivities = @[UIActivityTypePrint,
                                   UIActivityTypeCopyToPasteboard,
                                   UIActivityTypeSaveToCameraRoll,
                                   UIActivityTypeAddToReadingList];
    
    activityVC.excludedActivityTypes = excludeActivities;
    activityVC.view.layer.speed = 2.0;
    [self presentViewController:activityVC animated:YES completion:^{
        
        [ProgressHUD dismiss];
        [self.indicator stopAnimating];
        self.indicator.hidden = false;

    }];
    
    [activityVC setCompletionWithItemsHandler:^(NSString *activityType, BOOL completed, NSArray *returnedItems, NSError *activityError) {
        
        if (_playerAPlaying) {
            [self.avPlayer play];
        } else {
            [self.avPlayerTwo play];
        }
        _shareShowing = NO;

    }];
}

@end
