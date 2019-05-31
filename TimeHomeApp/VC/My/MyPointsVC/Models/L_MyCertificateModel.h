//
//  L_MyCertificateModel.h
//  TimeHomeApp
//
//  Created by 世博 on 2017/3/14.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface L_MyCertificateModel : NSObject

/**
 是否为赠予券  1是
 */
@property (nonatomic, strong) NSString *isexchange;
/**
 是否可用 1可用
 */
@property (nonatomic, strong) NSString *state;
/**
 可用个数
 */
@property (nonatomic, strong) NSString *number;

/**
 用户id
 */
@property (nonatomic, strong) NSString *userid;

@end
