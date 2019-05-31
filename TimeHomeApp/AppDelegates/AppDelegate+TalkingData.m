//
//  AppDelegate+TalkingData.m
//  TimeHomeApp
//
//  Created by ning on 2018/6/26.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "AppDelegate+TalkingData.h"

@implementation AppDelegate (TalkingData)

- (void)configTalkingData{
    //配置 TalkingData
    [TalkingData sessionStarted:@"4C8A8FAEBA294E6DB701FF33A9FB3635" withChannelId:@"AppStore"];
}

@end
