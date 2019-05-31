//
//  NetworkMonitoring.h
//  TimeHomeApp
//
//  Created by 优思科技 on 2018/3/31.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkMonitoring : NSObject
+ (instancetype)shareMonitoring;
/**
 启动网络监听
 */
-(void)start;

/**
 需要根据网络状态变化修改UI的地方使用

 @param block 网络变化回调
 */
-(void)needCallBack:(UpDateViewsBlock)block;

/**
 结束网络监听
 */
-(void)stop;

/**
 获取网络状态

 @return 返回网络状态  NoNetWork Wifi 2G 3G 4G
 */
-(NSString *)state;
@end
