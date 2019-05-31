//
//  PAVersionManager.m
//  TimeHomeApp
//
//  Created by Evagrius on 2018/5/9.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PAVersionManager.h"
#import "PAVersionService.h"
#import "PAVersionUpdateView.h"
@implementation PAVersionManager

SYNTHESIZE_SINGLETON_FOR_CLASS(PAVersionManager)

/**
 加载VersionManager
 */
+(void)load {
    [[NSNotificationCenter defaultCenter]addObserver:[PAVersionManager sharedPAVersionManager] selector:@selector(versionCheck) name:UIApplicationDidBecomeActiveNotification object:nil];
}

/**
 检查新版本
 */
- (void)versionCheck{
    
        PAVersionService * versionService = [[PAVersionService alloc]init];
       [versionService versionInfoCheck];
        versionService.successBlock = ^(PABaseRequestService *service) {
            // VersionModel版本号与时间校验
            PAVersionService * weakService = service;
            // 更新校验操作
            if ([self conformUpdate:weakService.versionModel]) {
                [self verifyUpdateStyle:weakService.versionModel];
            }
            // 不满足条件,默认不更新
        };
}

/**
 校验更新模式强制更新/普通更新

 @param versionModel versionModel description
 */
- (void)verifyUpdateStyle:(PAVersionModel *)versionModel{
    // 更新
    if (versionModel.needUpdate) {
        PAVersionUpdateView * updateView = [[PAVersionUpdateView alloc]init];
        if (versionModel.isForce == YES) {
            // 强制更新
            [updateView showForcedUpdate:versionModel shouldUpdate:^(id  _Nullable data, ResultCode resultCode) {
                [self updateApplication:versionModel.packageUrl];
            }];
            
        } else{
            // 普通更新
            [updateView showGeneralUpdate:versionModel shouldUpdate:^(id  _Nullable data, ResultCode resultCode) {
                [self updateApplication:versionModel.packageUrl];
            }];
        }
    }
}

- (void)updateApplication:(NSString *)downloadURL{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:downloadURL]];
}

/**
 校验是否可执行更新操作

 @param versionModel VersionModel
 @return YES can update
 */
- (BOOL)conformUpdate:(PAVersionModel *)versionModel{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    // 校验版本号:
    // 版本号相同情况下 return  no;
    if ([versionModel.version isEqualToString:kCurrentVersion]) {
        return NO;
    }
    // 版本号不一致情况下 首先判断本次请求是否与上次请求更新版本号是否一致
    if (![versionModel.version isEqualToString:[defaults objectForKey:@"PAVersionCode"]]) {
        // 如果不一致则弹出本次提醒,同时保存本次更新提醒,并且执行本次更新提示
        [self saveUpdateInfo:versionModel];
        return YES;
    }
    //版本号一致情况下判断本次请求是否与上次请求的时间间隔是否满足条件
    //获取更新间隔
    NSString * timeInterval = [defaults objectForKey:@"PAVersionTimeInterval"];
    //获取上次提示时间
    NSDate *lastDate = [defaults objectForKey:@"PAVersionTime"];
    //获取当前时间
    NSDate * date = [NSDate date];
    NSTimeInterval timerInterval = [date timeIntervalSinceDate:lastDate];
    if (timerInterval/3600 >= timeInterval.integerValue) {
        return YES;
    }
    return NO;
}

/**
 记录版本号与更新时间

 @param versionModel versionModel
 */
- (void)saveUpdateInfo:(PAVersionModel *)versionModel{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:versionModel.version forKey:@"PAVersionCode"];
    [defaults setObject:versionModel.timeInterval forKey:@"PAVersionTimeInterval"];
    [defaults setObject:[NSDate date] forKey:@"PAVersionTime"];
    [defaults synchronize];
}
@end
