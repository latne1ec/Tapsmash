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

@interface WelcomeViewController ()

@property (nonatomic, strong) AppDelegate *appDelegate;

@end

@implementation WelcomeViewController


-(BOOL)prefersStatusBarHidden {
    
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _appDelegate = [[UIApplication sharedApplication] delegate];
    
     if([UIScreen mainScreen].bounds.size.height < 568.0) {
         self.scoreLabel.frame = CGRectMake(120, 200, 200, 200);
         
         for (NSLayoutConstraint *constraint in self.view.constraints) {
             if (constraint.firstItem == self.scoreLabel) {
                 [self.view removeConstraint:constraint];
             }
         }
     }
    
    if([UIScreen mainScreen].bounds.size.height <= 568.0) {
        self.playLabel.font = [UIFont fontWithName:@"AvenirNext-Bold" size:33];
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

}

-(void)appWillResignActive {
    
     if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"localUser"] isEqualToString:@"YES"]) {
         
             if ([_appDelegate currentUser] != nil) {
                 int currentUserScore = [[[NSUserDefaults standardUserDefaults] objectForKey:@"localUserScore"] intValue];
                 [[_appDelegate currentUser] setObject:[NSNumber numberWithInt:currentUserScore] forKey:@"userScore"];
                 [[_appDelegate currentUser] incrementKey:@"runCount"];
                 [[_appDelegate currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                     if (error) {
                         
                     } else {
                     }
             }];
         }
     }
}

-(void)viewDidAppear:(BOOL)animated {
    
    int currentUserScore = [[[NSUserDefaults standardUserDefaults] objectForKey:@"localUserScore"] intValue];
    NSString *newString = [NSString stringWithFormat:@"%d", currentUserScore];
    self.scoreLabel.text = newString;
}

-(void)startShow {
    
    ContentViewController *cvc = [self.storyboard instantiateViewControllerWithIdentifier:@"Content"];
    cvc.view.layer.speed = 2.0;
    [self.navigationController pushViewController:cvc animated:NO];
    
}

- (IBAction)playButtonTapped:(id)sender {
    
    [self startShow];
}

@end
