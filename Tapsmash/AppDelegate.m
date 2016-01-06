//
//  AppDelegate.m
//  Tapsmash
//
//  Created by Evan Latner on 9/28/15.
//  Copyright © 2015 tapsmash. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [PFImageView class];
    [Parse enableLocalDatastore];
    [Parse setApplicationId:@"BbBVj41yKW4irlVK97Jys9iGFhe74bap3MHM4usH"
                  clientKey:@"araO3PcrVxnYtVbPJy5B3TJ8EccZjItOBVBVymv0"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];

    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0.161 green:0.157 blue:0.157 alpha:1]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    // Register for Push Notitications, if running iOS 8
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                        UIUserNotificationTypeBadge |
                                                        UIUserNotificationTypeSound);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                                 categories:nil];
        [application registerUserNotificationSettings:settings];
        [application registerForRemoteNotifications];
    } else {
        // Register for Push Notifications before iOS 8
        [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                         UIRemoteNotificationTypeAlert |
                                                         UIRemoteNotificationTypeSound)];
    }
    
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"hasRanAppV1"] isEqualToString:@"YES"]) {
        //do something
    } else {
        
        NSString *userId = [[NSUUID UUID] UUIDString];
        
        [[NSUserDefaults standardUserDefaults] setObject:userId forKey:@"userId"];
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"localUserScore"];
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"hasRanAppV1"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"localUser"] isEqualToString:@"YES"]) {
        //do something
        
        int currentUserScore = [[[NSUserDefaults standardUserDefaults] objectForKey:@"localUserScore"] intValue];
        
        NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
        
        PFQuery *query = [PFQuery queryWithClassName:@"CustomUser"];
        [query whereKey:@"userId" equalTo:userId];
        [query getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
            if (error) {
                
            } else {
                
                _currentUser = object;
                
                [self.currentUser incrementKey:@"runCount"];
                [self.currentUser setObject:[NSNumber numberWithInt:currentUserScore] forKey:@"userScore"];
                [self.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                    if (error) {
                        
                    } else {
                        
                    }
                }];
            }
        }];
        
    } else {
        
        NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
        
        PFACL *acl = [PFACL new];
        PFRole *role = [PFRole new];
        [acl setWriteAccess:false forRole:role];
        
        
        PFObject *newUser = [PFObject objectWithClassName:@"CustomUser"];
        [newUser setACL:acl];
        [newUser setObject:userId forKey:@"userId"];
        [newUser incrementKey:@"userScore" byAmount:[NSNumber numberWithInt:[[[NSUserDefaults standardUserDefaults] objectForKey:@"localUserScore"] intValue]]];
        [newUser incrementKey:@"runCount"];
        [newUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error) {
                
            } else {
                
                _currentUser = newUser;
                
                [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"localUser"];
                
                PFInstallation *currentInstallation = [PFInstallation currentInstallation];
                [currentInstallation setObject:newUser forKey:@"customUser"];
                [currentInstallation saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                    
                }];
            }
        }];
    }

    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {

    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    currentInstallation.channels = @[ @"global" ];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
}

- (void)applicationWillResignActive:(UIApplication *)application {
}
- (void)applicationDidEnterBackground:(UIApplication *)application {
}
- (void)applicationWillEnterForeground:(UIApplication *)application {
}
- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    if (currentInstallation.badge != 0) {
        currentInstallation.badge = 0;
        [currentInstallation saveEventually];
    }
}
- (void)applicationWillTerminate:(UIApplication *)application {
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
