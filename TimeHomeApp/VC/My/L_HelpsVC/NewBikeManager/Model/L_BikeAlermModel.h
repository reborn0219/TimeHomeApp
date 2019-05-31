//
//  L_BikeAlermModel.h
//  TimeHomeApp
//
//  Created by 世博 on 2017/9/6.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 二轮车报警记录
 */
@interface L_BikeAlermModel : NSObject

/**
 记录id
 */
@property (nonatomic, strong) NSString *theID;
/**
 自行车id
 */
@property (nonatomic, strong) NSString *bikeid;
/**
 时间
 */
@property (nonatomic, strong) NSString *systime;
/**
 报警内容
 */
@property (nonatomic, strong) NSString *content;
/**
 社区名称
 */
@property (nonatomic, strong) NSString *communityname;

@property (nonatomic, assign) CGFloat height;

@end
