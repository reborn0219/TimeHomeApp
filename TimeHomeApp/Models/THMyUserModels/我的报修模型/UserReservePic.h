//
//  UserReservePic.h
//  TimeHomeApp
//
//  Created by 世博 on 16/4/5.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

/**
 *   piclist中图片model
 */
#import <Foundation/Foundation.h>

@interface UserReservePic : NSObject
/**
 *  资源表id
 */
@property (nonatomic, strong) NSString *theID;
/**
 *  照片地址
 */
@property (nonatomic, strong) NSString *fileurl;
@end
