//
//  UserReserveLog.h
//  TimeHomeApp
//
//  Created by 世博 on 16/4/5.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

/**
 *  我的报修在线跟踪model
 */
#import <Foundation/Foundation.h>

@interface UserReserveLog : NSObject
/**
 *  处理状态 -1 不可维修的操作状态0 创建 1 已分配 2 处理中 3 已完成 4 已评价
 */
@property (nonatomic, strong) NSString *state;
/**
 *  操作的内容：app可直接显示
 */
@property (nonatomic, strong) NSString *content;
/**
 *  操作时间
 */
@property (nonatomic, strong) NSString *systime;
@end
