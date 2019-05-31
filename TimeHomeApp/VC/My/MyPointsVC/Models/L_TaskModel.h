//
//  L_TaskModel.h
//  TimeHomeApp
//
//  Created by 世博 on 2017/2/16.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 任务板model
 */
@interface L_TaskModel : NSObject

/**
 是否完成 1完成 0没有完成
 */
@property (nonatomic, strong) NSString *isfinished;

/**
 完成次数
 */
@property (nonatomic, strong) NSString *didtimes;

/**
 积分
 */
@property (nonatomic, strong) NSString *todayinte;

/**
 类型
 */
@property (nonatomic, strong) NSString *type;

@end
