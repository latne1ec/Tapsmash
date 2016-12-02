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
#import <OneSignal/OneSignal.h>
#import "UserMedia.h"

@interface AppDelegate ()

@property (strong, nonatomic) OneSignal *oneSignal;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [PFImageView class];
    [Parse enableLocalDatastore];
//    [Parse setApplicationId:@"BbBVj41yKW4irlVK97Jys9iGFhe74bap3MHM4usH"
//                  clientKey:@"araO3PcrVxnYtVbPJy5B3TJ8EccZjItOBVBVymv0"];
    
    
    [Parse initializeWithConfiguration:[ParseClientConfiguration configurationWithBlock:^(id<ParseMutableClientConfiguration> configuration) {
        configuration.applicationId = @"YOUR_APP_ID";
        configuration.server = @"http://YOUR_PARSE_SERVER:1337/parse";
    }]];
    
    
    
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    
    
//    self.oneSignal = [[OneSignal alloc] initWithLaunchOptions:launchOptions
//                                                        appId:@"e107a8d1-f144-4c23-928c-ab793299662c"
//                                           handleNotification:^(NSString *message, NSDictionary *additionalData, BOOL isActive) {
//                                               
//                                               NSLog(@"OneSignal Notification opened:\nMessage: %@", message);
//                                               if (additionalData) {
//                                                   NSLog(@"additionalData: %@", additionalData);
//                                                   
//                                                   NSString* customKey = additionalData[@"customKey"];
//                                                   if (customKey)
//                                                       NSLog(@"customKey: %@", customKey);
//                                               }
//                                               
//                                           } autoRegister:false];
    

    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"hasRanApp"] isEqualToString:@"YES"]) {
        //do something
    } else {
        
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"localUserScore"];
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"hasRanApp"];
        [[NSUserDefaults standardUserDefaults] setObject:@"1.05" forKey:@"appVersion"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"localUser"] isEqualToString:@"YES"]) {
        
        //User already created
        NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userObjectId"];
        
        PFQuery *query = [PFQuery queryWithClassName:@"CustomUser"];
        [query whereKey:@"objectId" equalTo:userId];
        [query getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
            if (error) {
                
            } else {
                
                _currentUser = object;
                
                //[self setOneSignalTag];
                //[self.oneSignal enableInAppAlertNotification:true];
            }
        }];
        
    } else {
        
        //User not here, create one
        PFObject *newUser = [PFObject objectWithClassName:@"CustomUser"];
        [newUser incrementKey:@"userScore" byAmount:[NSNumber numberWithInt:[[[NSUserDefaults standardUserDefaults] objectForKey:@"localUserScore"] intValue]]];
        [newUser incrementKey:@"runCount"];
        [newUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error) {
                
            } else {
                
                _currentUser = newUser;
                
                [[NSUserDefaults standardUserDefaults] setObject:newUser.objectId forKey:@"userObjectId"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"localUser"];
                
                PFInstallation *currentInstallation = [PFInstallation currentInstallation];
                [currentInstallation setObject:newUser forKey:@"customUser"];
                [currentInstallation saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                    
                }];
            }
        }];
    }
    
    
    _userPhotos = [[NSMutableArray alloc] init];
    _userVideos = [[NSMutableArray alloc] init];
    
    
    return YES;
}

-(void)registerUserForOneSignalPushNotifications {
    
    [self.oneSignal registerForPushNotifications];
}

-(void)setOneSignalTag {
    
    NSString *userObjectID = _currentUser.objectId;
    
    [self.oneSignal sendTags:(@{@"userObjectId" : userObjectID}) onSuccess:^(NSDictionary *result) {
        //NSLog(@"success");
        
    } onFailure:^(NSError *error) {
        //NSLog(@"didnt save yet");
        [self setOneSignalTag];
    }];
}

-(NSMutableArray *)getUserPhotos {
    
    UserMedia *userMedia = [[UserMedia alloc] init];
    return [userMedia getUserPhotos];
}

-(NSMutableArray *)getUserVideos {
    
    UserMedia *userMedia = [[UserMedia alloc] init];
    return [userMedia getUserVideos];
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
