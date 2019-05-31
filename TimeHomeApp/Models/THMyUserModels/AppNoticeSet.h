//
//  AppNoticeSet.h
//  TimeHomeApp
//
//  Created by 世博 on 16/7/29.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppNoticeSet : NSObject
/**
 *  接收消息通知 0 关闭 1 开通
 */
@property (nonatomic, strong) NSString *chatreceive;
/**
 *  通知显示消息详情 0 关闭 1 开通
 */
@property (nonatomic, strong) NSString *chatdetails;
/**
 *  声音开关 0 关闭 1 开通
 */
@property (nonatomic, strong) NSString *voiceopen;
/**
 *  提示音key
 */
@property (nonatomic, strong) NSString *voicekey;
/**
 *  振动 0 关闭 1 开通
 */
@property (nonatomic, strong) NSString *shockopen;
/**
 *  夜间免打扰 0 关闭 1 开通
 */
@property (nonatomic, strong) NSString *nightopen;
/**
 *  车辆防盗报警 0 关闭 1 开通
 */
@property (nonatomic, strong) NSString *carremind;

@end
