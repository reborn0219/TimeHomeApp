//
//  AppDelegate+Logger.m
//  TimeHomeApp
//
//  Created by ning on 2018/6/25.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "AppDelegate+Logger.h"

@implementation AppDelegate (Logger)

- (void)configCrashException{
    ///获取错误日志
    CrashException * crash=[CrashException sharedInstance];
    [crash installExceptionHandler];
}

@end
