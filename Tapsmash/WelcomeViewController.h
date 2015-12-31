//
//  WelcomeViewController.h
//  Tapsmash
//
//  Created by Evan Latner on 11/19/15.
//  Copyright © 2015 tapsmash. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>


@interface WelcomeViewController : UIViewController <UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (nonatomic) int *currentSkipCount;
@property (weak, nonatomic) IBOutlet UILabel *playLabel;

@property (nonatomic, strong) PFObject *currentUser;


- (IBAction)playButtonTapped:(id)sender;

@end
