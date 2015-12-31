//
//  HomeTableCell.h
//  Tapsmash
//
//  Created by Evan Latner on 9/30/15.
//  Copyright © 2015 tapsmash. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *postTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *postMetaLabel;
@property (weak, nonatomic) IBOutlet UIImageView *postThumbnail;
@property (weak, nonatomic) IBOutlet UIView *postReadLine;

@end
