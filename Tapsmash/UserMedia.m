//
//  UserMedia.m
//  Tapsmash
//
//  Created by Evan Latner on 3/15/16.
//  Copyright © 2016 tapsmash. All rights reserved.
//

#import "UserMedia.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "AssetBrowserItem.h"

@implementation UserMedia

-(NSMutableArray *)getUserPhotos {
    
    NSMutableArray *allPhotos = [[NSMutableArray alloc] init];
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            
            [group setAssetsFilter:[ALAssetsFilter allPhotos]];
            [group enumerateAssetsUsingBlock:^(ALAsset *asset, NSUInteger index, BOOL *stop) {
                if (asset) {
                    
                    NSMutableDictionary *photoDic = [[NSMutableDictionary alloc] init];
                    ALAssetRepresentation *representation = [asset defaultRepresentation];
                    UIImage *photo = [UIImage imageWithCGImage:[representation fullScreenImage]];
                    UIImage *thumbnail =  [UIImage imageWithCGImage:[asset thumbnail]];
                    [photoDic setValue:photo forKey:@"image"];
                    [photoDic setValue:thumbnail forKey:@"thumbnail"];
                    [allPhotos addObject:photoDic];
                    NSLog(@"pics: %lu", (unsigned long)allPhotos.count);
                    
                }
            }];
        } failureBlock: ^(NSError *error) {
            NSLog(@"No groups");
        }];
    });
    
    return allPhotos;
}


-(NSMutableArray *)getUserVideos {
    
    NSMutableArray *allVideos = [[NSMutableArray alloc] init];
    ALAssetsLibrary *assetLibrary = [[ALAssetsLibrary alloc] init];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        [assetLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            if (group) {
                
                [group setAssetsFilter:[ALAssetsFilter allVideos]];
                [group enumerateAssetsUsingBlock:^(ALAsset *asset, NSUInteger index, BOOL *stop) {
                    
                    if (asset) {
                        
                        NSMutableDictionary *videoDic = [[NSMutableDictionary alloc] init];
                        ALAssetRepresentation *defaultRepresentation = [asset defaultRepresentation];
                        NSString *uti = [defaultRepresentation UTI];
                        NSURL  *videoURL = [[asset valueForProperty:ALAssetPropertyURLs] valueForKey:uti];
                        NSString *title = [NSString stringWithFormat:@"video %d", arc4random()%100];
                        UIImage *image = [self createThumbnail:videoURL];
                        [videoDic setValue:image forKey:@"image"];
                        [videoDic setValue:title forKey:@"name"];
                        [videoDic setValue:videoURL forKey:@"url"];
                        [allVideos addObject:videoDic];
                    }
                }];
            }
            else {
            }
        } failureBlock:^(NSError *error) {
            NSLog(@"error enumerating AssetLibrary groups %@\n", error);
        }];
    });
    
    return allVideos;
    
}

-(UIImage *)createThumbnail: (NSURL *)videoUrl {
    
    AVURLAsset *asset = [AVURLAsset assetWithURL:videoUrl];
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc]initWithAsset:asset];
    CMTime time = kCMTimeZero;
    CGImageRef imageRef = [imageGenerator copyCGImageAtTime:time actualTime:NULL error:NULL];
    UIImage *thumbnail = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    if (thumbnail.size.width > 140) thumbnail = ResizePhoto(thumbnail, 320, 568); //300 x 400 -- 240 x 430
    
    NSData *imageData = UIImageJPEGRepresentation(thumbnail, 0.75);
    UIImage *img = [UIImage imageWithData:imageData];
    
    return img;
}

UIImage* ResizePhoto(UIImage *image, CGFloat width, CGFloat height) {
    
    CGSize size = CGSizeMake(width, height);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
