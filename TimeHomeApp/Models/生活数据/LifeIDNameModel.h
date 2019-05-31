//
//  LifeIDNameModel.h
//  TimeHomeApp
//
//  Created by 世博 on 16/4/9.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

/**
 *  生活中需要id和name的model
 */
#import <Foundation/Foundation.h>

@interface LifeIDNameModel : NSObject
/**
 *  区域id
 */
@property (nonatomic, strong) NSString *theID;
/**
 *  区域名称
 */
@property (nonatomic, strong) NSString *name;

@end
