//
//  PhotosCollectionCell.h
//  Tapsmash
//
//  Created by Evan Latner on 3/15/16.
//  Copyright © 2016 tapsmash. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotosCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) NSString *representedAssetIdentifier;
@property (nonatomic) BOOL hasSetImage;



@end
