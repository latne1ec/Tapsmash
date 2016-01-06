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

@end

@implementation ContentViewController

int currentIndex;
int currentSkipCount;

-(BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _appDelegate = [[UIApplication sharedApplication] delegate];
    
    _replayViewShowing = false;
    _currentlyQuerying = false;
    
    self.indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.indicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
    self.indicator.center = self.view.center;
    
    [self.view addSubview:self.indicator];
    [self.indicator setHidden:NO];
    [self.indicator startAnimating];
    
    self.view.backgroundColor = [UIColor blackColor];
    self.playerView.hidden = YES;
    [self queryForContent];
    
    
    self.avPlayer = [[AVPlayer alloc] init];
    self.avPlayerItem = [AVPlayerItem alloc];
    self.urlAsset = [AVURLAsset alloc];
    
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didCloseButtonTouch)];
    swipe.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipe];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:[self.avPlayer currentItem]];
    
    
    currentSkipCount = 0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillResignActive) name:UIApplicationWillResignActiveNotification object:nil]; 
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];

    [self.navigationController setNavigationBarHidden:YES];
    
//    if([UIScreen mainScreen].bounds.size.height <= 568.0) {
//        [self.subtitleLabel setFont:[UIFont boldSystemFontOfSize:19.0]];
//    } else {
//        [self.subtitleLabel setFont:[UIFont boldSystemFontOfSize:20.0]];
//    }
    
    self.subtitleLabel.adjustsFontSizeToFitWidth = YES;
    self.subtitleLabel.minimumScaleFactor = 0;
    
}

-(void)setupTimer {
    
    self.dasTimer = [NSTimer timerWithTimeInterval:1.25 target:self selector:@selector(resumeTheVideo) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.dasTimer forMode:NSDefaultRunLoopMode];
}

-(void)appDidBecomeActive {
    
    if (self.contentArray.count > 0) {

        PFObject *currentContent = [self.contentArray objectAtIndex:currentIndex];
        if ([[currentContent objectForKey:@"postType"] rangeOfString:@"video"].location != NSNotFound) {
            [self.avPlayer play];
        }
    }
}

-(void)resumeTheVideo {
    
    if (self.contentArray.count > 0) {
    
        PFObject *currentContent = [self.contentArray objectAtIndex:currentIndex];
        if ([[currentContent objectForKey:@"postType"] rangeOfString:@"video"].location != NSNotFound) {
            [self.avPlayer play];
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
     
        [self performSelector:@selector(fadehome) withObject:nil afterDelay:0.33];
        
    }
    
    if (_currentlyQuerying) {
        [self performSelector:@selector(fadehome) withObject:nil afterDelay:0.33];
    }
}

-(void)fadehome {
    
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    CATransition *transition = [CATransition animation];
    [transition setType:kCATransitionFade];
    [self.navigationController.view.layer addAnimation:transition forKey:@"someAnimation"];
    [UIApplication sharedApplication].statusBarHidden = NO;
    [self.navigationController popToRootViewControllerAnimated:NO];
    [CATransaction commit];
    
}

-(void)viewWillDisappear:(BOOL)animated {
    
    [[NSNotificationCenter defaultCenter] removeObserver:UIApplicationWillResignActiveNotification];
    [[NSNotificationCenter defaultCenter] removeObserver:UIApplicationDidBecomeActiveNotification];
    
    [self.avPlayer pause];
    [self.indicator setHidden:YES];
    [self.dasTimer invalidate];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if (self.webview.observationInfo == nil) {
    } else {
        [self.webview removeObserver:self forKeyPath:@"estimatedProgress"];
    }
}

-(void)viewWillAppear:(BOOL)animated {
    
    self.navigationController.navigationBar.backItem.hidesBackButton = YES;
    [self.navigationItem setHidesBackButton:YES animated:YES];
    currentIndex = 0;
    
}

-(void)handleSingleTap {
    
    currentSkipCount++;
    
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
    
    [self.avPlayerLayer removeFromSuperlayer];
    
    if (currentIndex+1 >= self.contentArray.count) {
        
        [self.indicator setHidden:YES];
        [self showReplayView];
        [self.dasTimer invalidate];
        
        
    } else {
    
        currentIndex = currentIndex + 1;
        
        PFObject *currentContent = [self.contentArray objectAtIndex:currentIndex];
        self.contentCountLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.contentArray.count - currentIndex];
        
        if ([[currentContent objectForKey:@"postType"] rangeOfString:@"video"].location != NSNotFound) {
        }
        [self.avPlayer pause];
        [self displayContent];
    }
}

-(void)showReplayView {
    
    _replayViewShowing = true;
    [self.avPlayer pause];
    
    PFObject *lastObject = [self.contentArray lastObject];
    [[NSUserDefaults standardUserDefaults] setObject:lastObject.objectId forKey:@"lastSeenContentId"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    self.replayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:self.replayView];
    self.replayView.backgroundColor = [UIColor colorWithRed:0.004 green:0.694 blue:0.953 alpha:1];
    self.replayButton = [[UIButton alloc] init];
    self.replayButton.frame = CGRectMake(0, 0, 300, 100);
    self.replayButton.center = self.view.center;
    [self.replayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.replayButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateSelected];
    self.replayButton.titleLabel.font = [UIFont fontWithName:@"AvenirNext-Bold" size:24];
    self.replayButton.titleLabel.numberOfLines = 2;
    [self.replayButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.replayButton setTitle:@"no new posts 🔄\ntap to replay" forState:UIControlStateNormal];
    [self.replayButton addTarget:self action:@selector(replayShow) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *buttonTwo = [[UIButton alloc] init];
    buttonTwo.frame = CGRectMake(self.replayButton.frame.origin.x, self.replayButton.frame.origin.y+200, 300, 100);
    //buttonTwo.center = self.view.center;
    [buttonTwo setTitleColor:[UIColor colorWithWhite:1 alpha:0.94] forState:UIControlStateNormal];
    [buttonTwo setTitleColor:[UIColor colorWithWhite:1 alpha:0.94] forState:UIControlStateSelected];
    buttonTwo.titleLabel.font = [UIFont fontWithName:@"AvenirNext-Bold" size:22];
    buttonTwo.titleLabel.numberOfLines = 2;
    [buttonTwo.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [buttonTwo setTitle:@"home" forState:UIControlStateNormal];
    [buttonTwo addTarget:self action:@selector(didCloseButtonTouch) forControlEvents:UIControlEventTouchUpInside];
    
    [self.replayView addSubview:self.replayButton];
    
}

-(void)replayShow {
    
    self.view.backgroundColor = [UIColor blackColor];
    
    self.replayView.backgroundColor = [UIColor blackColor];
    [self.view sendSubviewToBack:self.replayView];
    
    [self setupTimer];
    
    self.subtitleLabel.text = @"";
    
    currentIndex = 0;
    currentSkipCount = 0;
    self.contentCountLabel.text = @"";
    self.imageView.hidden = YES;
    self.avPlayerLayer.hidden = YES;
    
    [self.contentArray removeAllObjects];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.replayView removeFromSuperview];
    });
    
    [self.replayView removeFromSuperview];
    [self replayQuery];
    
}

-(void)displayContent {
    
    PFObject *currentContent = [self.contentArray objectAtIndex:currentIndex];
    
    if ([[currentContent objectForKey:@"postType"] isEqualToString:@"web"]) {
        
        [self showWebviewContent];
    }
    
    if ([[currentContent objectForKey:@"postType"] rangeOfString:@"video"].location != NSNotFound) {
        
        [self.view addSubview:self.indicator];
        [self.indicator setHidden:NO];
        [self.indicator startAnimating];
        [self.view bringSubviewToFront:self.indicator];
        [self playDasVideo];
        self.imageView.image = [UIImage imageNamed:@"black"];
        
    } else {
        self.avPlayerLayer.hidden = YES;
        [self.avPlayerLayer removeFromSuperlayer];
        [self showPicture];
    }
}


- (NSString *)extractYoutubeIdFromLink:(NSString *)link {
    
    NSString *regexString = @"((?<=(v|V)/)|(?<=be/)|(?<=(\\?|\\&)v=)|(?<=embed/))([\\w-]++)";
    NSRegularExpression *regExp = [NSRegularExpression regularExpressionWithPattern:regexString
                                                                            options:NSRegularExpressionCaseInsensitive
                                                                              error:nil];
    
    NSArray *array = [regExp matchesInString:link options:0 range:NSMakeRange(0,link.length)];
    if (array.count > 0) {
        NSTextCheckingResult *result = array.firstObject;
        return [link substringWithRange:result.range];
    }
    return nil;
}

//// ********************* VIDEO

-(void)playerItemDidReachEnd:(NSNotification *)notification  {
        
    if (currentIndex+1 >= self.contentArray.count) {
        [self.dasTimer invalidate];
        self.dasTimer = nil;
    }
    [self handleSingleTap];
}

-(void)playDasVideo {
    
    [self.avPlayer pause];
    
    //self.view.backgroundColor = [UIColor blackColor];

    PFObject *currentContent = [self.contentArray objectAtIndex:currentIndex];
    NSString *urlString = [currentContent objectForKey:@"postLink"];
    NSURL *url = [NSURL URLWithString:urlString];
    
    self.subtitleLabel.text = [currentContent objectForKey:@"postTitle"];
    
    self.avAsset = [AVAsset assetWithURL:url];
    self.avPlayerItem = [AVPlayerItem playerItemWithAsset:self.avAsset];
    self.avPlayer = [AVPlayer playerWithPlayerItem:self.avPlayerItem];
    self.avPlayerLayer = [AVPlayerLayer playerLayerWithPlayer: self.avPlayer];
    self.avPlayerLayer.frame = self.view.layer.bounds;
    [self.view.layer addSublayer:self.avPlayerLayer];
    [self.avPlayer play];
    [self.view bringSubviewToFront:self.subtitleLabel];
    [self.view bringSubviewToFront:self.likeButton];
    //[self.indicator setHidden:YES];
    //[self.indicator stopAnimating];

}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary *)change context:(void *)context {
    
    if (self.avPlayer.currentItem.status == AVPlayerStatusReadyToPlay) {
        
        [self.avPlayer play];
    }
    if ([keyPath isEqualToString:@"estimatedProgress"] && object == self.webview) {
        CGFloat progress;
        progress = self.webview.estimatedProgress;
        
        if (progress > 0.97) {
            
            [self.indicator setHidden:YES];
            [self.indicator stopAnimating];
        }
        
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

//// ********************* VIDEO


-(void)showWebviewContent {
    
    PFObject *currentContent = [self.contentArray objectAtIndex:currentIndex];
    
    if (floor(NSFoundationVersionNumber) < NSFoundationVersionNumber_iOS_7_1) {
        
        self.regWebview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        self.regWebview.backgroundColor = [UIColor blackColor];
        self.regWebview.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
        self.regWebview.delegate = self;
        self.regWebview.scrollView.bounces = YES;
        self.regWebview.scrollView.scrollEnabled = NO;
        //self.webview.userInteractionEnabled = NO;
        //[self.regWebview addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
        
        NSString *urlString = [currentContent objectForKey:@"postLink"];
        NSURL *url = [NSURL URLWithString:urlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.regWebview loadRequest:request];
        [self.view addSubview:self.regWebview];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap)];
        tap.numberOfTapsRequired = 1;
        [self.regWebview addGestureRecognizer:tap];
        
        [self.regWebview addSubview:self.indicator];
        [self.indicator setHidden:NO];
        [self.indicator startAnimating];
        
    }
    
    else {
        
        NSString *source = @"document.body.style.background = \"#000000\";";
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        WKUserContentController *controller = [[WKUserContentController alloc] init];
        config.userContentController = controller;
        WKUserScript *script = [[WKUserScript alloc] initWithSource:source injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        [controller addUserScript:script];
        
        self.webview = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) configuration:config];  ///MADE THIS * 2
        
        self.webview.backgroundColor = [UIColor blackColor];
        self.webview.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
        self.webview.navigationDelegate = self;
        self.webview.scrollView.bounces = YES;
        self.webview.scrollView.scrollEnabled = NO;
        //self.webview.userInteractionEnabled = NO;
        [self.webview addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
        
        NSString *urlString = [currentContent objectForKey:@"postLink"];
        NSURL *url = [NSURL URLWithString:urlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.webview loadRequest:request];
        [self.view addSubview:self.webview];
    
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap)];
        tap.numberOfTapsRequired = 1;
        [self.webview addGestureRecognizer:tap];
        
        [self.webview addSubview:self.indicator];
        [self.indicator setHidden:NO];
        [self.indicator startAnimating];
    }
}

-(void)showPicture {
    
    [self.avPlayer pause];
    
    //self.view.backgroundColor = [UIColor blackColor];
    
    self.imageView.hidden = NO;
    [self.view bringSubviewToFront:self.imageView];
    self.subtitleLabel.hidden = NO;
    self.imageView.image = [UIImage imageNamed:@"black"];
    
    PFObject *currentContent = [self.contentArray objectAtIndex:currentIndex];
    
    self.subtitleLabel.text = [currentContent objectForKey:@"postTitle"];
    
    SDWebImageManager *managerOne = [SDWebImageManager sharedManager];
    
    
    NSString *urlString = [currentContent objectForKey:@"postLink"];
    NSURL *url = [NSURL URLWithString:urlString];
    
    if ([managerOne cachedImageExistsForURL:url]) {
        NSData *data = [NSData dataWithContentsOfURL:url];
        self.imageView.image = [UIImage imageWithData:data];
        self.imageView.hidden = NO;
        [self.view bringSubviewToFront:self.imageView];
        [self.view bringSubviewToFront:self.contentCountLabel];
        [self.view bringSubviewToFront:self.bottomFade];
        [self.view bringSubviewToFront:self.subtitleLabel];
        [self.view bringSubviewToFront:self.likeButton];
        
    } else {
        [managerOne downloadImageWithURL:url options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        }
                    completed:^(UIImage *images, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                        
                        //self.imageView.image = [UIImage imageNamed:@"black"];
                        self.imageView.image = images;
                        self.imageView.hidden = NO;
                        [self.view bringSubviewToFront:self.imageView];
                        [self.view bringSubviewToFront:self.contentCountLabel];
                        [self.view bringSubviewToFront:self.bottomFade];
                        [self.view bringSubviewToFront:self.subtitleLabel];
                        [self.view bringSubviewToFront:self.likeButton];
                    }];
        }
}

- (void)didCloseButtonTouch {
    
    [self.navigationController popToRootViewControllerAnimated:NO];
}

-(void)queryForContent {
    
    _currentlyQuerying = true;
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:( NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond ) fromDate:[[NSDate alloc] init]];
    
    [components setHour:-29];
    [components setMinute:0];
    [components setSecond:0];
    NSDate *yesterday = [cal dateByAddingComponents:components toDate: [NSDate date] options:0];
    
    
    PFQuery *query = [PFQuery queryWithClassName:@"Posts"];
    [query whereKey:@"postChannel" notEqualTo:@"nil"];
    [query whereKey:@"createdAt" greaterThanOrEqualTo:yesterday];
    [query orderByDescending:@"createdAt"];
    [query setLimit:100];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (error) {
            _currentlyQuerying = false;
        } else {

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
            
                for (PFObject *object in self.contentArray) {
                    NSString *objectId = [object valueForKey:@"objectId"];
                    
                    i++;
                    
                    if ([objectId isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"lastSeenContentId"]]) {
                        
                        currentIndex = i;
                        [self displayContent];
                        [self setupTimer];
                        [self downloadImages];
                        self.contentCountLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.contentArray.count-currentIndex];
                        [self addTapTapRecoginzer];
                        return;
                    } 
                }
                
            [self displayContent];
            [self downloadImages];
            [self setupTimer];
            [self addTapTapRecoginzer];
            self.contentCountLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.contentArray.count];
                
            }
        }
    }];
}

-(void)replayQuery {
    
    _currentlyQuerying = true;
    
    [self.view addSubview:self.indicator];
    [self.indicator setHidden:NO];
    [self.indicator startAnimating];
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:( NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond ) fromDate:[[NSDate alloc] init]];
    
    [components setHour:-29];
    [components setMinute:0];
    [components setSecond:0];
    NSDate *yesterday = [cal dateByAddingComponents:components toDate: [NSDate date] options:0];
    
    
    PFQuery *query = [PFQuery queryWithClassName:@"Posts"];
    [query whereKey:@"postChannel" notEqualTo:@"nil"];
    [query whereKey:@"createdAt" greaterThanOrEqualTo:yesterday];
    [query orderByDescending:@"createdAt"];
    [query setLimit:100];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (error) {
        } else {
            
            _currentlyQuerying = false;
            self.contentArray = [objects mutableCopy];
            NSArray* reversedArray = [[self.contentArray reverseObjectEnumerator] allObjects];
            self.contentArray = [reversedArray mutableCopy];
            
            [self displayContent];
            self.contentCountLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.contentArray.count];
            [self.view bringSubviewToFront:self.contentCountLabel];
            
            [self addTapTapRecoginzer];
        }
    }];
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
                    //NSLog(@"Image: %@", images);
                        
                }];
            }
        }
    }
}

@end
