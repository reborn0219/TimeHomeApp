//
//  DateTimeUtils.h
//  TimeHomeApp
//
//  Created by UIOS on 16/4/5.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateTimeUtils : NSObject

/**
 *  用过nsdate转出string
 */
+(NSString *)StringFromDateTime:(NSDate *)systime;

/**
 *  个人通知时间格式 今天hh：mm，昨天hh：mm，前天hh：mm，具体日期yyyy-mm-dd hh：mm
 */
+(NSString *)StringToDateTime:(NSString *)systime;

+(NSString *)FriendsStringToDateTime:(NSString *)systime;
/**
 *  消息列表页时间格式 hh：mm，昨天，前天，具体日期yyyy-mm-dd
 */
+(NSString *)StringToDateTimeWithTime:(NSString *)systime;
///判断5分钟以后显示时间
+(BOOL)isfiveminutes:(NSDate *)newDate fromLastDate:(NSDate*)lastDate;


@end
