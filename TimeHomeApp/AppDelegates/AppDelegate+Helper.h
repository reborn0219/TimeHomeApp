//
//  AppDelegate+Helper.h
//  TimeHomeApp
//
//  Created by ning on 2018/6/25.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (Helper)

//获取手机型号
- (NSString *)iphoneType;

//获取蓝牙设备权限数据
-(void)getBlueTouchData;

//判断登录超期
- (BOOL)isBeyonbdDays;

//获取当前网络状态
+ (NSString *)getNetWorkStates;

//检查用户是否需要登录
-(BOOL)checkVersionNeedLogin;

//获取当前显示的视图控制器
- (UIViewController *)getCurrentViewController;

//显示消息提示并自动消失
+ (void)showToastMsg:(NSString *)message Duration:(float)duration;

@end
