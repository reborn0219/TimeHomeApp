//
//  AppDelegate+JPush.h
//  TimeHomeApp
//
//  Created by ning on 2018/6/26.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "AppDelegate.h"
#import <JMessage/JMessage.h>

@interface AppDelegate (JPush)

-(void)registJPush:(NSDictionary *)launchOptions;

//设置推送标签
- (BOOL)setTags:(NSArray *)aTag error:(NSError **)error;

@end
