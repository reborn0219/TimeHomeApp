//
//  AppDelegate+UserStatistics.h
//  TimeHomeApp
//
//  Created by ning on 2018/6/26.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (UserStatistics)

//配置统计数据
- (void)configUserStatistics;

/**
 添加用户操作到数据库
 
 @param statisticsDic 统计用户数据字典
 */
-(void)addStatistics:(NSDictionary *)statisticsDic;

/**
 标记统计开始
 
 @param viewkey 页面Key值
 */
-(void)markStatistics:(NSString *)viewkey;
@end
