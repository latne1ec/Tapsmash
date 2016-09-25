//
//  AppDelegate.h
//  Tapsmash
//
//  Created by Evan Latner on 9/28/15.
//  Copyright © 2015 tapsmash. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Tapsmash-swift.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) NSString *currentSkipCountString;
@property (nonatomic, strong) PFObject *currentUser;
@property (nonatomic, strong) NSMutableArray *userPhotos;
@property (nonatomic, strong) NSMutableArray *userVideos;


-(void)registerUserForOneSignalPushNotifications;
-(NSMutableArray *)getUserPhotos;
-(NSMutableArray *)getUserVideos;

@end
