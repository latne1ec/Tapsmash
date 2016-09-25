//
//  VideosCollectionViewController.m
//  Tapsmash
//
//  Created by Evan Latner on 3/14/16.
//  Copyright © 2016 tapsmash. All rights reserved.
//

#import "VideosCollectionViewController.h"

@interface VideosCollectionViewController ()

@end

@implementation VideosCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
 }

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _videos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    VideosCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    NSDictionary *dic = [_videos objectAtIndex:indexPath.item];
    
    cell.imageView.image = [dic valueForKey:@"image"];
    
    return cell;
}

@end
