//
//  HomeTableViewController.h
//  Tapsmash
//
//  Created by Evan Latner on 9/30/15.
//  Copyright © 2015 tapsmash. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "HomeTableCell.h"
#import "SDWebImageManager.h"
#import "SSARefreshControl.h"



@interface HomeTableViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray *stories;
@property (nonatomic, strong) UIButton *titleButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *score;




@end
