//
//  PhotosCollectionViewController.m
//  Tapsmash
//
//  Created by Evan Latner on 3/14/16.
//  Copyright © 2016 tapsmash. All rights reserved.
//

#import "PhotosCollectionViewController.h"
#import "PhotosCollectionCell.h"
#import <Photos/Photos.h>
#import <PhotosUI/PhotosUI.h>


@interface PhotosCollectionViewController ()

@property (strong, nonatomic) PHFetchResult *allPhotosFetchResult;
@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, strong) PHImageManager *manager;


@end

@implementation PhotosCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    
    [self getPics];
}

-(void)getPics {
    
    PHFetchOptions *allPhotosOptions = [PHFetchOptions new];
    allPhotosOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    self.allPhotosFetchResult = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:allPhotosOptions];
    
    self.manager = [[PHImageManager alloc] init];
    
    _imageArray = [[NSMutableArray alloc] init];
    
    for (int i; i < self.allPhotosFetchResult.count; i++) {
        PHAsset *asset = [self.allPhotosFetchResult objectAtIndex:i];
        [self.manager requestImageForAsset:asset
                                targetSize:PHImageManagerMaximumSize
                               contentMode:PHImageContentModeAspectFill
                                   options:nil
                             resultHandler:^(UIImage *result, NSDictionary *info) {
                                 [_imageArray addObject:result];
                                 NSLog(@"result: %@", _imageArray);
                }];
    }
    [self.collectionView reloadData];
    NSLog(@"hiiii");
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _imageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PhotosCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];

    UIImage *image = _imageArray[indexPath.item];
    cell.imageView.image = image;

    PHAsset *asset = self.allPhotosFetchResult[indexPath.item];
    
    cell.representedAssetIdentifier = asset.localIdentifier;
    
    cell.imageView.image = image;

//    [self.manager requestImageForAsset:asset
//                            targetSize:PHImageManagerMaximumSize
//                           contentMode:PHImageContentModeAspectFill
//                               options:nil
//                         resultHandler:^(UIImage *result, NSDictionary *info) {
//                             // Set the cell's thumbnail image if it's still showing the same asset.
//                             if ([cell.representedAssetIdentifier isEqualToString:asset.localIdentifier]) {
//                                 cell.imageView.image = result;
//                                 //NSLog(@"hi: %@", cell.representedAssetIdentifier);
//                             }
//                         }];

    return cell;
}

@end
