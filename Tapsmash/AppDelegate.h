//
//  AppDelegate.h
//  Tapsmash
//
//  Created by Evan Latner on 9/28/15.
//  Copyright © 2015 tapsmash. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) NSString *currentSkipCountString;
@property (nonatomic, strong) PFObject *currentUser;


@end
