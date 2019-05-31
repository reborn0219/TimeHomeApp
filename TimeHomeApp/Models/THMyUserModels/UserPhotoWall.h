//
//  UserPhotoWall.h
//  TimeHomeApp
//
//  Created by 世博 on 16/3/31.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

/**
 *  用户照片墙model
 */
#import <Foundation/Foundation.h>

@interface UserPhotoWall : NSObject
/**
 *  照片墙id
 */
@property (nonatomic, strong) NSString *theID;
/**
 *  照片地址
 */
@property (nonatomic, strong) NSString *fileurl;
/**
 *  照片(自己本地选的图片)
 */
@property (nonatomic, strong) UIImage *image;

//--------------------------2017.01.20增加-------------
/**
 被选中(车辆添加用到)
 */
@property (nonatomic, assign) BOOL isSelected;

@end
