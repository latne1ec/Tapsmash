//
//  SubmitContentViewController.m
//  Tapsmash
//
//  Created by Evan Latner on 3/14/16.
//  Copyright © 2016 tapsmash. All rights reserved.
//

#import "SubmitContentViewController.h"
#import "AppDelegate.h"

@interface SubmitContentViewController ()
@property (nonatomic) CAPSPageMenu *pageMenu;
@property (nonatomic, strong) AppDelegate *appDelegate;


@end

@implementation SubmitContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _appDelegate = [[UIApplication sharedApplication] delegate];
    
    //[_appDelegate getUserPhotos];
    //[_appDelegate getUserVideos];
    
    
    VideosCollectionViewController *vcvc = [self.storyboard instantiateViewControllerWithIdentifier:@"Videos"];
    vcvc.title = @"videos";
    //vcvc.videos = [_appDelegate getUserVideos];
    PhotosCollectionViewController *pcvc = [self.storyboard instantiateViewControllerWithIdentifier:@"Photos"];
    pcvc.title = @"photos";
    //pcvc.photos = [_appDelegate getUserPhotos];
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSArray *controllerArray = @[vcvc, pcvc];
    NSDictionary *parameters = @{
                                 CAPSPageMenuOptionScrollMenuBackgroundColor: [UIColor whiteColor],
                                 CAPSPageMenuOptionViewBackgroundColor: [UIColor whiteColor],
                                 CAPSPageMenuOptionSelectionIndicatorColor: [UIColor whiteColor],
                                 CAPSPageMenuOptionBottomMenuHairlineColor: [UIColor whiteColor],
                                 CAPSPageMenuOptionMenuItemFont: [UIFont fontWithName:@"AvenirNext-Bold" size:18.0],
                                 CAPSPageMenuOptionMenuHeight: @(100.0),
                                 CAPSPageMenuOptionMenuItemWidth: @(90.0),
                                 CAPSPageMenuOptionCenterMenuItems: @(YES)
                                 };
    
    _pageMenu = [[CAPSPageMenu alloc] initWithViewControllers:controllerArray frame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height) options:parameters];
    _pageMenu.view.layer.speed = 5.0;
    [self.view addSubview:_pageMenu.view];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"cancel" style:UIBarButtonItemStylePlain target:self action:@selector(closeTheController)];
    
}

-(void)closeTheController {
    
    [self dismissViewControllerAnimated:NO completion:nil];
    
}

-(void)viewWillAppear:(BOOL)animated {
    
    self.navigationController.navigationBar.translucent = false;
    
}

@end
