//
//  WelcomeViewController.m
//  Tapsmash
//
//  Created by Evan Latner on 11/19/15.
//  Copyright © 2015 tapsmash. All rights reserved.
//

#import "WelcomeViewController.h"
#import "ContentViewController.h"
#import "AppDelegate.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "AssetBrowserItem.h"
#import "SubmitContentViewController.h"

@interface WelcomeViewController ()

@property (nonatomic, strong) AppDelegate *appDelegate;
@property (nonatomic, strong) DismissAnimator *dismissAnimator;
@property (nonatomic, strong) Interactor *interactor;

@end

@implementation WelcomeViewController


-(BOOL)prefersStatusBarHidden {
    
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _appDelegate = [[UIApplication sharedApplication] delegate];
    self.interactor = [[Interactor alloc] init];
    self.dismissAnimator = [[DismissAnimator alloc] init];
    
    
     if([UIScreen mainScreen].bounds.size.height < 568.0) {
         self.scoreLabel.frame = CGRectMake(120, 200, 200, 200);
         
         for (NSLayoutConstraint *constraint in self.view.constraints) {
             if (constraint.firstItem == self.scoreLabel) {
                 [self.view removeConstraint:constraint];
             }
         }
     }
    
    if([UIScreen mainScreen].bounds.size.height <= 568.0) {
        self.playLabel.font = [UIFont fontWithName:@"AvenirNext-Heavy" size:30];
    }
    
    self.view.backgroundColor = [UIColor colorWithRed:0.004 green:0.694 blue:0.953 alpha:1];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(startShow)];
    tap.numberOfTapsRequired = 1;
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
    
    [self.navigationController setNavigationBarHidden:YES];
    
    if ([PFUser currentUser]) {
        [PFUser logOut];
    }
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"localUser"] isEqualToString:@"YES"]) {
        
        int currentUserScore = [[[NSUserDefaults standardUserDefaults] objectForKey:@"localUserScore"] intValue];
        NSString *newString = [NSString stringWithFormat:@"%d", currentUserScore];
        self.scoreLabel.text = newString;
        
    } else {
    }
    
    self.scoreLabel.adjustsFontSizeToFitWidth = YES;
    self.scoreLabel.minimumScaleFactor = 0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillResignActive) name:UIApplicationWillResignActiveNotification object:nil];
    
    [self.uploadButton addTarget:self action:@selector(uploadButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)uploadButtonTapped {
    
    SubmitContentViewController *svc = [self.storyboard instantiateViewControllerWithIdentifier:@"Submit"];
    [self presentViewController:svc animated:NO completion:nil];
}

-(void)appWillResignActive {
    
     if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"localUser"] isEqualToString:@"YES"]) {
         
             if ([_appDelegate currentUser] != nil) {
                 int currentUserScore = [[[NSUserDefaults standardUserDefaults] objectForKey:@"localUserScore"] intValue];
                 NSString *appVersion = [[NSUserDefaults standardUserDefaults] objectForKey:@"appVersion"];
                 [[_appDelegate currentUser] setObject:[NSNumber numberWithInt:currentUserScore] forKey:@"userScore"];
                 [[_appDelegate currentUser] incrementKey:@"runCount"];
                 [[_appDelegate currentUser] setObject:appVersion forKey:@"appVersion"];
                 [[_appDelegate currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                     if (error) {
                         
                     } else {
                     }
             }];
         }
     }
}

-(void)viewDidAppear:(BOOL)animated {
    
    [self performSelector:@selector(updateUserScore) withObject:nil afterDelay:0.04];
    
}

-(void)updateUserScore {
    
    if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"AnimateScore"] isEqualToString:@"YES"]) {
        
        int currentUserScore = [[[NSUserDefaults standardUserDefaults] objectForKey:@"localUserScore"] intValue];
        NSString *newString = [NSString stringWithFormat:@"%d", currentUserScore];
        self.scoreLabel.text = newString;
        
    } else {
        
        [UIView animateKeyframesWithDuration:0.085 delay:0.0 options:0 animations:^{
            self.scoreLabel.transform = CGAffineTransformMakeScale(1.04, 1.04);
        } completion:^(BOOL finished) {
            int currentUserScore = [[[NSUserDefaults standardUserDefaults] objectForKey:@"localUserScore"] intValue];
            NSString *newString = [NSString stringWithFormat:@"%d", currentUserScore];
            self.scoreLabel.text = newString;
            [UIView animateKeyframesWithDuration:0.06 delay:0.0 options:0 animations:^{
                self.scoreLabel.transform = CGAffineTransformMakeScale(1.0, 1.0);
            } completion:^(BOOL finished) {
            }];
        }];
        
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"AnimateScore"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

-(void)startShow {
    
    ContentViewController *cvc = [self.storyboard instantiateViewControllerWithIdentifier:@"Content"];
    //cvc.view.layer.speed = 2.0;
    cvc.modalPresentationStyle = UIModalPresentationCurrentContext;
    cvc.transitioningDelegate = self;
    cvc.interactor = self.interactor;
    [self presentViewController:cvc animated:NO completion:nil];
    
}

- (IBAction)playButtonTapped:(id)sender {
    
    [self startShow];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    
    return self.dismissAnimator;
    
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>) animator {
    
    if (self.interactor.hasStarted) {
        return self.interactor;
    } else {
        return  nil;
    }
}

@end
