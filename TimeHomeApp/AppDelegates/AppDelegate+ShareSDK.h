//
//  AppDelegate+ShareSDK.h
//  TimeHomeApp
//
//  Created by ning on 2018/6/25.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "AppDelegate.h"
//新浪微博SDK头文件
#import "WeiboSDK.h"

@interface AppDelegate (ShareSDK)<WeiboSDKDelegate>
- (void)configShareSDK;
@end
