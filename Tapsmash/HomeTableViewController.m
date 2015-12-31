//
//  HomeTableViewController.m
//  Tapsmash
//
//  Created by Evan Latner on 9/30/15.
//  Copyright © 2015 tapsmash. All rights reserved.
//

#import "HomeTableViewController.h"
#import "UIImageView+WebCache.h"
#import "DateTools.h"
#import "ProgressHUD.h"
#import "ContentViewController.h"


@interface HomeTableViewController () <SSARefreshControlDelegate>

@property (nonatomic, strong) SSARefreshControl *refreshControl;

@end

@implementation HomeTableViewController

@synthesize refreshControl;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"HERE YOU GO: %d", [[[NSUserDefaults standardUserDefaults] objectForKey:@"currentSkipCount"] intValue]);
    
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorColor = [UIColor colorWithRed:0.918 green:0.918 blue:0.918 alpha:1];
    
    self.refreshControl = [[SSARefreshControl alloc] initWithScrollView:self.tableView andRefreshViewLayerType:SSARefreshViewLayerTypeOnScrollView];
    self.refreshControl.delegate = self;
    
    [self.score setTitle:@"100"];
    
    self.titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.titleButton setTitle:@"tapsmash" forState:UIControlStateNormal];
    self.titleButton.frame = CGRectMake(0, 0, 70, 44);
    self.titleButton.titleLabel.font = [UIFont systemFontOfSize:23];
    [self.titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.titleButton addTarget:self action:@selector(didTapTitleView:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = self.titleButton;
    
    [self queryForTen];

}

- (void)beganRefreshing {
    
    [self queryForTen];
}

- (IBAction)didTapTitleView:(id) sender {
    
    if (self.stories.count > 0) {
        
        [UIView animateWithDuration:0.1 animations:^{
            
            self.view.transform = CGAffineTransformMakeScale(1.06, 1.06);
            self.titleButton.transform = CGAffineTransformMakeScale(1.03, 1.03);
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.1 animations:^{
                self.view.transform = CGAffineTransformMakeScale(1.0, 1.0);
                self.titleButton.transform = CGAffineTransformMakeScale(1.0, 1.0);
                
            } completion:^(BOOL finished) {
                
            }];
        }];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.stories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        
        static NSString *CellIdentifier = @"Cell";
    
        HomeTableCell *cell = (HomeTableCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[HomeTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        PFObject *object = [self.stories objectAtIndex:indexPath.row];
    
            //Stories
            
            cell.postThumbnail.layer.cornerRadius = 2;
            [cell.postThumbnail sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[object objectForKey:@"postThumbnail"]]] placeholderImage:[UIImage imageNamed:@"sanFran.jpg"]];
            
            
            if ([[[PFUser currentUser] objectForKey:@"viewedPosts"] containsObject:object.objectId]) {
                cell.postReadLine.alpha = 0.12;
            }
            else {
                cell.postReadLine.alpha = 1.0;
            }
            
            
            NSDate *date = object.createdAt;
            NSString *ago = [date timeAgoSinceNow];
            
            cell.postTitleLabel.text = [object objectForKey:@"postTitle"];
            NSString *category = [[object objectForKey:@"postChannel"] capitalizedString];
            cell.postMetaLabel.text = [NSString stringWithFormat:@"%@ - %@", category, ago];
            
            if (cell.gestureRecognizers.count == 0) {
                UITapGestureRecognizer *doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushToView:)];
                doubleTapGestureRecognizer.delegate = (id)self;
                doubleTapGestureRecognizer.numberOfTapsRequired = 1;
                doubleTapGestureRecognizer.delaysTouchesBegan = YES;
                [cell addGestureRecognizer:doubleTapGestureRecognizer];
            }
            
            return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 108;
}

-(void)pushToView: (UIGestureRecognizer *)sender {
    
    CGPoint tapLocation = [sender locationInView:self.tableView];
    NSIndexPath *tappedIndexPath = [self.tableView indexPathForRowAtPoint:tapLocation];
    //StoryTableCell *cell = (StoryTableCell *)[self.tableView cellForRowAtIndexPath:tappedIndexPath];
    PFObject *object = [self.stories objectAtIndex:tappedIndexPath.row];
    [[PFUser currentUser] addObject:object.objectId forKey:@"viewedPosts"];
    [[PFUser currentUser] saveInBackground];
    [UIView animateWithDuration:0.1 animations:^{
        
    } completion:^(BOOL finished) {
        
    }];
    
    ContentViewController *cvc = [self.storyboard instantiateViewControllerWithIdentifier:@"Content"];
    [self presentViewController:cvc animated:NO completion:nil];
    
}


-(void)queryForTen {
    
    PFQuery *query = [PFQuery queryWithClassName:@"Posts"];
    [query orderByDescending:@"createdAt"];
    [query setLimit:5];
    [query findObjectsInBackgroundWithBlock:^(NSArray * objects, NSError *error) {
        if (error) {
            
        } else {
            self.stories = [objects mutableCopy];
            [self.tableView reloadData];
            [self performSelector:@selector(endRefresh) withObject:nil afterDelay:1.1];
            [ProgressHUD dismiss];
                        
        }
    }];
}

-(void)endRefresh {
    
    [self.refreshControl endRefreshing];
}

@end
