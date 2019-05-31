//
//  AppDelegate+Message.h
//  TimeHomeApp
//
//  Created by ning on 2018/6/27.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (Message)

-(void)setPushNoticeWithLaunchOptions:(NSDictionary *)launchOptions;

-(void)pushNotice:(id)object;

-(NSString *)logDic:(NSDictionary *)dic;

//消息分类处理统计计数
-(void)dealPushMsg:(NSDictionary *)dic :(NSString *)message :(NSString *)type;

//同步聊天消息
-(void)synchronousChatData:(NSDictionary *)dic :(NSString *)message;

//设置消息存储名称
-(void)setMsgSaveName;

@end
