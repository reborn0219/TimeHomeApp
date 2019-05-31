//
//  PANoticeManager.h
//  TimeHomeApp
//
//  Created by Evagrius on 2018/4/24.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PANoticeManager : NSObject
{
}
@property (nonatomic, assign)  BOOL canGetNewMessage;

/**
 保存推送所需设备信息至后台
 */
+(void)saveDeviceInfo;


/**
 解绑设备信息
 */
+(void)unBindDeviceInfo;


/**
 处理后台状态下接受到的推送消息

 @param notification 推送消息body中cjson内容
 */
+(void)manageNotification:(NSDictionary *)notification;


/**
 处理后台状态下接收到的旧版本推送消息

 @param oldNotification 推送消息body
 */
+ (void)managerOldNotification:(NSDictionary *)oldNotification;
/**
 处理极光透传消息

 @param message 透传消息body
 */
+(void)manageJPushReceiveMessage:(NSDictionary *)message;

/**
 旧平安社区透传消息整合
 
 @param dic content字典
 @param message 展示内容
 @param type 推送类型
 */
+(void)managerOldReceiveMessage:(NSDictionary *)dic message:(NSString *)message type:(NSString *)type;
@end
