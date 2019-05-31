//
//  SDPhotoBrowser.h
//  photobrowser
//
//  Created by aier on 15-2-3.
//  Copyright (c) 2015年 aier. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SDButton, SDPhotoBrowser;

@protocol SDPhotoBrowserDelegate <NSObject>

@required

- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index;

@optional

- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index;

@end

typedef void(^saveButtonDidClickBlock)(NSInteger index);

@interface SDPhotoBrowser : UIView <UIScrollViewDelegate>

@property (nonatomic, copy) saveButtonDidClickBlock saveButtonDidClickBlock;
/**
 *  单例
 *
 *  @return
 */
+(instancetype)sharedInstanceSDPhotoBrower;

@property (nonatomic, weak) UIView *sourceImagesContainerView;
@property (nonatomic, assign) NSInteger currentImageIndex;
@property (nonatomic, assign) NSInteger imageCount;

/**
 是否从我的头像页面进来
 */
@property (nonatomic, assign) BOOL isFromPhotoWall;

@property (nonatomic, weak) id<SDPhotoBrowserDelegate> delegate;

-(void)getUserHeader:(NSInteger)index;

- (void)show;

- (void)hidden;

@end
