//
//  DateUitls.h
//  QYgaosu
//
//  Created by us on 15/7/24.
//  Copyright © 2015年 uskj. All rights reserved.
//
/**
 日期工具类，处理各种日期显示
 **/

#import <Foundation/Foundation.h>

@interface DateUitls : NSObject
//计算两个日期之间的天数
+(NSInteger) calcDaysFromBegin:(NSDate *)inBegin today:(NSDate *)today;

//计算两个日期之间的天数
+(NSInteger) calcDaysFromBeginForString:(NSString *)inBegin today:(NSString *)end;


//获取今天日期+星期
+(NSString *) getTodayWeekDate;
//获取今天日期年-月-日
+(NSString *)getTodayDateFormatter:(NSString *)formatter;
//日期转NSString
+(NSString *)stringFromDate:(NSDate *)date DateFormatter:(NSString *)formatter;

//日期转NSString按格式转
+(NSString *)stringFromDateToStr:(NSString *)date DateFormatter:(NSString *)formatter;


//NSString转日期
+(NSDate *)DateFromString:(NSString *)date DateFormatter:(NSString *)formatter;

//获取日期中的天
+(NSString *)getDayForDate:(NSString *)date;
//获取日期中的月
+(NSString *)getMonthForDate:(NSString *)date;
//获取日期中的年
+(NSInteger)getYearForDate:(NSDate *)date;



+(NSDate *)tranfromStingToData:(NSString *)timeStr;


+(NSString *)tranfromTime:(long long)ts;


////刚刚，XX分钟前，XX小时前，XX天前，XX月前，XX年前
+(NSString *)prettyDateWithReference:(NSDate *)reference;


+(NSString *)prettyDateWithData:(NSDate *)reference;

+(NSString *)TimeDifference:(NSDate *)reference;
+(BOOL)FiveMinutesDifference:(NSString *)newStr :(NSString *)lastStr;

///今天hh：mm，昨天hh：mm，前天hh：mm，具体日期yyyy-mm-dd hh：mm
+(NSString *) formatDateForDayHHMM:(NSString *) dateStr;
///yyyy年MM月dd日_MM月dd日 跨年  yyyy年MM月dd日_yyyy年MM月dd日
+(NSString *) formatterForActivityDate:(NSString *)startDate end:(NSString *)endDate;

/**
 *  hh：mm，昨天，前天，具体日期yyyy-mm-dd
 */
+ (NSString *)formateDateWithDateString:(NSString *)dateString;

/**
 判断当前时间是否在某个时间段内
 */
+ (BOOL)validateWithStartTime:(NSString *)startTime withExpireTime:(NSString *)expireTime;
@end
