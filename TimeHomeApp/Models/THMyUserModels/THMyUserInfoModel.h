//
//  THMyUserInfoModel.h
//  TimeHomeApp
//
//  Created by 李世博 on 16/3/28.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UserData.h"

@interface THMyUserInfoModel : NSObject
/**
 *  错误编码，参照错误表
 */
@property (nonatomic, strong) NSNumber *errcode;
/**
 *  错误提示
 */
@property (nonatomic, strong) NSString *errmsg;
/**
 *  用户信息
 */
@property (nonatomic, strong) UserData *map;

@end
